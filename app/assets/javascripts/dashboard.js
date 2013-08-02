(function() {


  var app;

  app = angular.module("HubCRM", ["ngResource", "ui.date"]);

  app.factory("PeopleAPI", [
    "$resource", function($resource) {
      return {
        api:
        //@todo make this dyanmic eg /people.json OR /people/55.json
        $resource("/people.json", { id: "@id" }, {
        })
      }
    }
  ]);

  app.filter('active', ["$location", function($location){
    return function(input) {
      var state = '';
      var where = $location.$$absUrl.split('/').pop()
      if ( where === input ) { state = 'active'; }
      return state
    }
  }]);
  
  app.factory("Note", [
    "$resource", function($resource) {
      return {
        api:
        $resource("/notes/:id", { id: "@id" }, {
          update: { method: "PUT" }
        })
      }
    }
  ]);

  app.factory("Reminders", [
    "$resource", function($resource) {
      return {
        api:
        $resource("/notes/reminders_all.json", { id: "@id" }, {
          query: { method: "GET",  isArray:true }
        })
      }
    }
  ]);

  app.service('Messages', function() {
        return {
            trigger_message: function (message, type) {
              var n = noty({
                text: message, 
                type: type, 
                force: true, 
                timeout: false,
                animation: {
                  open: {height: 'toggle'},
                  close: {height: 'toggle'},
                  easing: 'swing',
                  speed: 500 // opening & closing animation speed
                },
                callback: {
                    onShow: function() {},
                    afterShow: function() {},
                    onClose: function() {},
                    afterClose: function() {}
                },
              });
            }
        }
  });

  app.factory("NoteByPerson", [
    "$resource", function($resource) {
      return {
        api:
        $resource("/people/:id/notes.json", { id: "@id" }, {
          update: { method: "PUT" }
        })
      }
    }
  ]);

  app.factory("TaskCount", [
    "$resource", "$http", "$rootScope", function($resource, $http, $rootScope) {
      return {
        set_tasks_count: function(data) {
          var Tasks = '';
          if($(data).length === 0){
            $rootScope.TasksAll = $resource('/notes/tasks_all.json')
          } else {
            $rootScope.TasksAll = data;
          }
          var count = '';
          angular.forEach($rootScope.TasksAll, function(v, k) {
            if (v.task_status === false) {
              count++;
            }
          });
          return count;
        }
      };
  }]);

  app.factory("RemindersCount", [
    "$resource", "$http", "$rootScope", "Reminders", function($resource, $http, $rootScope, Reminders) {
      var count = 1;
      return {
        set_reminders_count: function(data) {
          if($(data).length === 0){
            //console.log(Reminders.api.query());
            //$rootScope.count = Reminders.api.query();
          } else {
            $rootScope.count = data;
          }
          //console.log($rootScope.count);
          // angular.forEach($rootScope.RemindersAll, function(v, k) {
          //   if (v.task_status === false) {
          //     count++;
          //   }
          // });
          
          return count;
        }
      };
  }]);

  this.DashCtrl = [
    "$scope", "$http", "PeopleAPI", "NoteByPerson", "Note", "Messages", function($scope, $http, PeopleAPI, NoteByPerson, Note, Messages) {
      var documentBody = document.body;
  	  $scope.dash = []
      $scope.people = PeopleAPI.api.query();
      $scope.note = {};
      $scope.message = {};
      $scope.notes = {};

      $scope.deleteNote = function() {
        Messages.trigger_message('Note Deleted', 'success');
        var original_id = this.note.id;
        Note.api.delete({id: this.note.id}, function(response){
          var count = 0;
          angular.forEach($scope.notes, function(v, k) {
            if (v.id == original_id) {
              $scope.notes[count] = [];
            }
            count++;
          });   
          $.noty.closeAll();
        });
      };

      $scope.noteCreate = function() {
        if(this.note.id) {
          Note.api.update({id: this.note.id}, this.note, function(response){
            $scope.note = response;
            var n = noty({text: 'Note Updated', type: 'success'});  
            var count = 0;
            angular.forEach($scope.notes, function(v, k) {
              if (v.id == $scope.note.id) {
                $scope.notes[count] = $scope.note;
              }
              count++;
            });
            $.noty.closeAll();
          });        
        } else {
          var note = Note.api.save($scope.note);
          $scope.note = {};
          Messages.trigger_message('Note Created', 'success');
          $scope.notes.push(note);
          $.noty.closeAll();
        }
      };

      $scope.notePerson = function() {
        jQuery.noty.closeAll();
        $scope.note.related_profile_id = this.person.network_id
        var notes = NoteByPerson.api.query({id: this.person.id});
        var message = "Loaded notes realted to " + this.person.first_name + ' ' + this.person.last_name;
        Messages.trigger_message(message, 'success');
        $scope.notes = notes
      };

      $scope.$showNote = function(note) {
        console.log(note);
      };

      $scope.editNote = function() {
        $scope.note = Note.api.get({id: this.note.id })
        jQuery(window).scrollTop();
        $(documentBody).animate({scrollTop: $('body').offset().top}, 500,'easeInOutCubic');
      }
    }
  ];

  this.NavCtrl = [
    "$scope", "$http", function($scope, $http) {
      
      $http({method: 'GET', url: '/notes/tasks_open.json'}).
        success(function(data){
          $scope.tasks_count = data
      });    

      $http({method: 'GET', url: '/notes/reminders_open.json'}).
        success(function(data){
          $scope.reminder_count = data
      });

    }
  ];

  this.RemindersCtrl = [
    "$scope", "$http", "PeopleAPI", "NoteByPerson", "Note", "Messages", function($scope, $http, PeopleAPI, NoteByPerson, Note, Messages) {
      var documentBody = document.body;
      
      // $scope.set_reminder_count = function(notes) {
      //   var count = '';
      //   angular.forEach(notes, function(v, k) {
      //       if (v.task_status === false) {
      //         count++;
      //       }
      //     });
      //     return count;
      // }

      $scope.dash = []
      $scope.people = PeopleAPI.api.query();
      $scope.note = {};
      $scope.message = {};
      $scope.notes = {};
      $scope.reminder_count = '';

      // $http({method: 'GET', url: '/notes/reminders_all.json'}).
      //   success(function(data){
      //     $scope.notes = data;
      //     $scope.reminder_count = $scope.set_reminder_count(data);
      // });

      $scope.deleteNote = function() {
        Messages.trigger_message('Note Deleted', 'success');
        var original_id = this.note.id;
        Note.api.delete({id: this.note.id}, function(response){
          var count = 0;
          angular.forEach($scope.notes, function(v, k) {
            if (v.id == original_id) {
              $scope.notes[count] = [];
            }
            count++;
          });   
        });
        $.noty.closeAll();
        $scope.reminder_count = $scope.set_reminder_count($scope.notes);
      };

      $scope.noteCreate = function() {
        if(this.note.id) {
          Note.api.update({id: this.note.id}, this.note, function(response){
            $scope.note = response;
            var n = noty({text: 'Note Updated', type: 'success'});  
            var count = 0;
            angular.forEach($scope.notes, function(v, k) {
              if (v.id == $scope.note.id) {
                $scope.notes[count] = $scope.note;
              }
              count++;
            });
            $.noty.closeAll();
          });        
        } else {
          var note = Note.api.save($scope.note);
          $scope.note = {};
          Messages.trigger_message('Note Created', 'success');
          $scope.notes.push(note);
          $.noty.closeAll();
        }
      };

      $scope.notePerson = function() {
        jQuery.noty.closeAll();
        $scope.note.related_profile_id = this.person.network_id
        var notes = NoteByPerson.api.query({id: this.person.id});
        var message = "Loaded notes realted to " + this.person.first_name + ' ' + this.person.last_name;
        Messages.trigger_message(message, 'success');
        $scope.notes = notes
      };

      $scope.$showNote = function(note) {
        //console.log(note);
      };

      $scope.editNote = function() {
        $scope.note = Note.api.get({id: this.note.id })
        jQuery(window).scrollTop();
        $(documentBody).animate({scrollTop: $('body').offset().top}, 500,'easeInOutCubic');
      }
    }
  ];


this.TasksCtrl = [
    "$scope", "$http", "PeopleAPI", "NoteByPerson", "Note", "Messages", "TaskCount", "RemindersCount", "Reminders", function($scope, $http, PeopleAPI, NoteByPerson, Note, Messages, TaskCount, RemindersCount, Reminders) {
      var documentBody = document.body;
      
      $scope.dash = []
      $scope.people = PeopleAPI.api.query();
      $scope.note = {};
      $scope.message = {};
      $scope.notes = {};
      $scope.reminder_count = '';

      $http({method: 'GET', url: '/notes/tasks_all.json'}).
        success(function(data){
          $scope.notes = data;
          $scope.tasks_count = TaskCount.set_tasks_count(data);
      });

      $scope.deleteNote = function() {
        Messages.trigger_message('Note Deleted', 'success');
        var original_id = this.note.id;
        Note.api.delete({id: this.note.id}, function(response){
          var count = 0;
          angular.forEach($scope.notes, function(v, k) {
            if (v.id == original_id) {
              $scope.notes[count] = [];
            }
            count++;
          });   
        });
        $.noty.closeAll();
        $scope.reminder_count = TaskCount.set_tasks_count($scope.notes);
      };

      $scope.noteCreate = function() {
        if(this.note.id) {
          Note.api.update({id: this.note.id}, this.note, function(response){
            $scope.note = response;
            var n = noty({text: 'Note Updated', type: 'success'});  
            var count = 0;
            angular.forEach($scope.notes, function(v, k) {
              if (v.id == $scope.note.id) {
                $scope.notes[count] = $scope.note;
              }
              count++;
            });
            $.noty.closeAll();
          });        
        } else {
          var note = Note.api.save($scope.note);
          $scope.note = {};
          Messages.trigger_message('Note Created', 'success');
          $scope.notes.push(note);
          $.noty.closeAll();
        }
      };

      $scope.notePerson = function() {
        jQuery.noty.closeAll();
        $scope.note.related_profile_id = this.person.network_id
        var notes = NoteByPerson.api.query({id: this.person.id});
        var message = "Loaded notes realted to " + this.person.first_name + ' ' + this.person.last_name;
        Messages.trigger_message(message, 'success');
        $scope.notes = notes
      };

      $scope.$showNote = function(note) {
        //console.log(note);
      };

      $scope.editNote = function() {
        $scope.note = Note.api.get({id: this.note.id })
        jQuery(window).scrollTop();
        $(documentBody).animate({scrollTop: $('body').offset().top}, 500,'easeInOutCubic');
      }
    }
  ];
}).call(this);
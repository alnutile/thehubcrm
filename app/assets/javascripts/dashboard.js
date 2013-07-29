(function() {


  var app;

  app = angular.module("HubCRM", ["ngResource", "ui.date"]);

  app.factory("PeopleAPI", [
    "$resource", function($resource) {
      return {
        api:
        //@todo make this dyanmic eg /people.json OR /people/55.json
        $resource("/people.json", { id: "@id" }, {
          update: { method: "PUT" }
        })
      }
    }
  ]);
  
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

  this.DashCtrl = [
    "$scope", "$http", "PeopleAPI", "NoteByPerson", "Note", function($scope, $http, PeopleAPI, NoteByPerson, Note) {

  	  $scope.dash = []
      $scope.people = PeopleAPI.api.query();
      $scope.note = {};
      $scope.message = {};
      $scope.notes = {};

      $scope.noteCreate = function() {
        var note = Note.api.save($scope.note)
        $scope.note = {};
        $scope.message = { type: 'success', message: "Note Created" }
        //$scope.notes.push(note)
      };

      $scope.notePerson = function() {
        $scope.note.related_profile_id = this.person.network_id
        $scope.message = { type: 'success', message: "Note now related to " + this.person.first_name + ' ' + this.person.last_name }
        var notes = NoteByPerson.api.query({id: this.person.id});
        $scope.notes = notes
      };
    }
  ];

}).call(this);
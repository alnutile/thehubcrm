DEFAULT_CONFIG = {
    'development' => {
      'hook_into' => :fakeweb,
      'cassette_library_dir' => 'development_cassettes',
      'allow_http_connections_when_no_cassette' => true
    }
  }
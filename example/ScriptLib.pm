package ScriptLib;
use Mojo::Base -base, -signatures;

use Carp 'croak';
use Mojo::UserAgent;
use Sentry;
use Sentry::Severity;

has foo => undef;
has ua  => sub { Mojo::UserAgent->new };

sub foo1 ($self, $value) {
  $self->foo2($self->foo, $value),;
}

sub foo2 ($self, $value, $x = undef) {
  my $tx = $self->ua->get('https://www.heise.de/select/');
  warn 'request done. Code: ' . $tx->res->code;
  Sentry->add_breadcrumb({
    message  => 'breadcrumb in foo2',
    type     => 'debug',
    category => 'ui.click',
    data     => {some => 'data', bla => ['a', 'b']}
  });
  $self->foo3;
}

sub foo3 {
  Sentry->add_breadcrumb({
    type     => 'http',
    category => 'xhr',
    level    => Sentry::Severity->Debug,
    data     => {
      url         => "http://example.com/api/1.0/users",
      method      => "GET",
      status_code => 200,
      reason      => "OK"
    }
  });
  die 'exception aus ScriptLib.pm';

  # croak 'exception aus ScriptLib.pm';
}

1;

use strict;
use warnings;

package WebService::Instapaper;

use LWP::UserAgent;
use Carp;
use URI;
use URI::QueryParam;

=head1 VERSION

=cut

# ABSTRACT: turns baubles into trinkets

our $VERSION = '0.01';

use constant INSTAPAPER_URI => 'https://www.instapaper.com/api/add';

sub new {
    my ( $class, %attr ) = @_;

    my $self = {};
    $self->{username} = $attr{username} || "";
    $self->{password} = $attr{password} || "";

    $self->{_ua} = LWP::UserAgent->new(
        agent   => 'WebService::Instapaper/0.1',
        cookie  => {},
        timeout => 30,
    );

    bless $self, $class;
}

sub username {
    my ( $self, $username ) = @_;

    $self->{username} = $username;
}

sub password {
    my ( $self, $password ) = @_;

    $self->{password} = $password;
}

sub credentials {
    my ( $self, $username, $password ) = @_;

    $self->username($username);
    $self->password($password);
}

sub add {
    my ( $self, %params ) = @_;

    croak "No username!" unless $self->{username} ne "";
    croak "No URI to read_later!" unless exists $params{url};

    my $uri = URI->new(INSTAPAPER_URI);
    $uri->query_param( url => $params{url} );

    my $request = HTTP::Request->new( GET => $uri, );
    $request->authorization_basic( $self->{username}, $self->{password} );

    my $response = $self->{_ua}->request($request);

    $self->{_last_code}    = $response->code();
    $self->{_last_message} = $response->message();

    if ( $response->code() == 201 ) {
        return 1;
    }
    else {
        return 0;
    }
}

sub message {
    my ($self) = @_;

    return $self->{_last_message} if exists $self->{_last_message};
}

sub code {
    my ($self) = @_;

    return $self->{_last_code} if exists $self->{_last_code};
}

1;

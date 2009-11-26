package WebService::CookPad;
use Any::Moose;

our $VERSION = '0.01';

use WebService::CookPad::Keyword;
use WebService::CookPad::Search;

use Carp;
use LWP::UserAgent;
use XML::Simple;
use URI;
use Try::Tiny;

has [qw/uuid key/] => (
    is       => 'rw',
    isa      => 'Str',
    required => 1,
);

has version => (
    is      => 'rw',
    isa     => 'Str',
    default => '1.0',
);

has ua => (
    is         => 'rw',
    isa        => 'LWP::UserAgent',
    lazy_build => 1,
);

has xs => (
    is         => 'rw',
    isa        => 'XML::Simple',
    lazy_build => 1,
);

has _authorized => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);

no Any::Moose;

sub _build_ua {
    my ($self) = @_;

    my $ua = LWP::UserAgent->new;
    $ua->agent(sprintf 'cookpad/%s CFNetwork', $self->version);
    $ua->env_proxy;

    $ua;
}

sub _build_xs {
    my ($self) = @_;

    my $xs = XML::Simple->new( KeyAttr => [] );
}

sub _auth {
    my ($self) = @_;

    my $res = $self->_call('auth', { k => $self->key });

    if ($res->{result} and $res->{result} eq 'OK') {
        $self->_authorized(1);
    }
    else {
        if ($res->{message}) {
            croak 'Auth failed: ' . $res->{message};
        }
        else {
            croak 'Auth failed';
        }
    }
}

sub _call {
    my ($self, $method, $params) = @_;

    if (!$self->_authorized and $method ne 'auth') {
        $self->_auth;
    }

    my $uri = URI->new('http://api.cookpad.com/api/' . $method);
    $uri->scheme('https') if $method eq 'auth';

    $uri->query_form(
        uuid => $self->uuid,
        $params ? %$params : (),
    );

    my $res = $self->ua->get($uri);

    local $XML::Simple::PREFERRED_PARSER = 'XML::Parser';
    if ($res->is_success) {
        my $xml;
        try {
            $xml = $self->xs->XMLin($res->content);
        } catch {
            croak sprintf 'API "%s" failed: %s', $method, $_;
        }
    }
    else {
        croak sprintf 'API "%s" failed: %s', $method, $res->status_line;
    }
}

sub popular_keywords {
    my ($self) = @_;

    my $res = $self->_call('popular_keywords');
    if (my $keyword = $res->{Keyword}) {
        return map {
            WebService::CookPad::Keyword->new(
                name  => $_->{name},
                rank  => $_->{rank}{content},
                last  => $_->{last}{content},
                point => $_->{point}{content},
            ),
        } @$keyword;
    }
    else {
        croak 'Invalid response from server';
    }
}

sub search {
    my ($self, %params) = @_;

    croak 'keyword required' unless $params{keyword};
    $params{size} ||= 10;

    my $res = $self->_call('search', \%params);
    WebService::CookPad::Search->new_from_xml($res);
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

WebService::CookPad - Module abstract (<= 44 characters) goes here

=head1 SYNOPSIS

    use WebService::CookPad;
    
    my $api = WebService::CookPad->new(
        uuid => 'your iphone unique identifier',
        key  => 'api key',
    );
    
    # popular_keywords
    for my $keyword ($api->popular_keywords) {
        print sprintf("%d: %s\n", $keyword->rank, $keyword->name);
    }

=head1 DESCRIPTION

Stub documentation for this module was created by ExtUtils::ModuleMaker.
It looks like the author of the extension was negligent enough
to leave the stub unedited.

Blah blah blah.

=head1 AUTHOR

Daisuke Murase <typester@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2009 by Daisuke Murase

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

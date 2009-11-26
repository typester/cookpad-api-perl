package WebService::CookPad::Recipe;
use Any::Moose;
use Carp;

has [qw/id title description author author_image ingredient photo published thumbnail tsukurepo_count/] => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;

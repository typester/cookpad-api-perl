package WebService::CookPad::HotRecipe;
use Any::Moose;

extends 'WebService::CookPad::Recipe';

has accepted => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;


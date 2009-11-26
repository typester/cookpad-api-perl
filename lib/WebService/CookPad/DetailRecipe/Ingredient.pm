package WebService::CookPad::DetailRecipe::Ingredient;
use Any::Moose;

has [qw/name quantity/] => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;


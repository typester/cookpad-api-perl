package WebService::CookPad::DetailRecipe::Step;
use Any::Moose;

use WebService::CookPad::DetailRecipe::Types;

has memo => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has image => (
    is       => 'ro',
    isa      => 'WebService::CookPad::DetailRecipe::Step::Image',
    required => 1,
    coerce   => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;



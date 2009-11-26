package WebService::CookPad::DetailRecipe;
use Any::Moose;

use WebService::CookPad::DetailRecipe::Types;
use WebService::CookPad::DetailRecipe::Ingredient;
use WebService::CookPad::DetailRecipe::Step;

has [qw/advice author author_image description history photo serving title/] => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has [qw/tsukurepo_count tsukurepo_users/] => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has ingredients => (
    is       => 'ro',
    isa      => 'WebService::CookPad::DetailRecipe::Ingredients',
    required => 1,
    coerce   => 1,
);

has steps => (
    is       => 'ro',
    isa      => 'WebService::CookPad::DetailRecipe::Steps',
    required => 1,
    coerce   => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;

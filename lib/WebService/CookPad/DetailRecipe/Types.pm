package WebService::CookPad::DetailRecipe::Types;
use Any::Moose;
use Any::Moose '::Util::TypeConstraints';

subtype 'WebService::CookPad::DetailRecipe::ArrayOfHash'
    => as 'ArrayRef[HashRef]';

subtype 'WebService::CookPad::DetailRecipe::Ingredients'
    => as 'ArrayRef[WebService::CookPad::DetailRecipe::Ingredient';

subtype 'WebService::CookPad::DetailRecipe::Steps'
    => as 'ArrayRef[WebService::CookPad::DetailRecipe::Step]';

coerce 'WebService::CookPad::DetailRecipe::Ingredients'
    => from 'WebService::CookPad::DetailRecipe::ArrayOfHash'
    => via {
        [map { WebService::CookPad::DetailRecipe::Ingredient->new($_) } @$_]
    };

coerce 'WebService::CookPad::DetailRecipe::Steps'
    => from 'WebService::CookPad::DetailRecipe::ArrayOfHash'
    => via {
        [map { WebService::CookPad::DetailRecipe::Step->new($_) } @$_]
    };

subtype 'WebService::CookPad::DetailRecipe::Step::Image'
    => as 'Str';
coerce 'WebService::CookPad::DetailRecipe::Step::Image'
    => from 'HashRef'
    => via { '' };

1;

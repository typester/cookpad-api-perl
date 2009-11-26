package WebService::CookPad::Keyword;
use Any::Moose;

has name => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has [qw/rank last/] => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has point => (
    is       => 'ro',
    isa      => 'Num',
    required => 1,
);

no Any::Moose;

__PACKAGE__->meta->make_immutable;

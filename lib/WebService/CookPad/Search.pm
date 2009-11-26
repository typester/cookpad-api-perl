package WebService::CookPad::Search;
use Any::Moose;
use Carp;

use WebService::CookPad::Recipe;

has count => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);

has related_keywords => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

has recipes => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

no Any::Moose;

sub new_from_xml {
    my ($class, $xml) = @_;

    my $count = 0;
    if ($xml->{info}) {
        $count = $xml->{info}{count}{content};
    }

    my @related_keywords;
    if (my $keywords = $xml->{keywords}{keyword}) {
        @related_keywords = map { $_->{word} } @$keywords;
    }

    my @recipes;
    if (my $recipes = $xml->{recipes}{recipe}) {
        @recipes = map {
            WebService::CookPad::Recipe->new(
                id              => $_->{id}{content},
                title           => $_->{title} || '',
                description     => $_->{description} || '',
                author          => $_->{author} || '',
                author_image    => $_->{'author-image'} || '',
                ingredient      => !ref($_->{ingredient}) ? $_->{ingredient} || '' : '',
                photo           => $_->{photo} || '',
                published       => $_->{published} || '',
                thumbnail       => $_->{thumbnail} || '',
                tsukurepo_count => $_->{'tsukurepo-count'}{content} || 0,
            )
        } @$recipes;
    }

    $class->new(
        count            => $count,
        related_keywords => \@related_keywords,
        recipes          => \@recipes,
    );
}

__PACKAGE__->meta->make_immutable;

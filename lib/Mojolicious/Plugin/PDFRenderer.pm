package Mojolicious::Plugin::PDFRenderer;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::JSON qw/decode_json/;

sub register {
    my ( $self, $app, $opts ) = @_;
    # writing it now...
}

# ABSTRACT: Uses wkhtmltopdf via PDF::WebKit to render your app exactly as it looks in Chrome/WebKit but vector scalable and in PDF.
1;

=head1 SYNOPSIS

    package App;
    use Mojo::Base 'Mojolicious';

    sub startup {
        my $self = shift;

        $self->plugin( 'Mojolicious::Plugin::PDFRenderer' );
        # ...
    }

Then go to http://yourapp:3000/any/route, take a good look, then go to http://yourapp:3000/any/route.pdf. Cool, huh?

=head1 REQUIREMENTS

=over 2

=item L<PDF::WebKit>

=item L<"wkhtmltopdf"|http://wkhtmltopdf.org/>

=back

=cut

package Mojolicious::Plugin::PDFRenderer;
use Mojo::Base 'Mojolicious::Plugin';
use PDF::WebKit;

sub register {
    my ( $self, $app, $opts ) = @_;
    $opts->{ '-args-override' } //= 1 unless exists $opts->{ '-args-override' };
    my $args_override = delete $opts->{ '-args-override' };
    $app->plugin( 'Mojolicious::Plugin::Args' ) if $args_override;
    $app->hook( around_action => sub {
        my ( $next, $c, $action, $last ) = @_;
        my $url  = $c->req->url->to_abs;
        return $next->() unless $c->stash->{format} and $c->stash->{format} eq 'pdf';
        $c->respond_to( pdf => sub {
            my $url  = $c->req->url->to_abs;
               $url =~ s/\.pdf.*$//i;

            $app->log->debug( "...fetching url $url for pdf" );

            my %opts = %{ $opts };
            do {
                my %args = $c->args;
                $opts{ $_ } = $args{ $_ } for keys %args;
                $app->log->debug( "pdf args override...", $app->dumper( \%opts ) ) if %args;
            } if $args_override;
            my $kit = new PDF::WebKit ( $url, %opts );
            my $pdf = $kit->to_pdf;

            $c->res->headers->content_type( 'application/pdf' );
            $c->res->body( $pdf );
            $c->rendered( 200 );
        } );
    } );
}

# ABSTRACT: Uses wkhtmltopdf via PDF::WebKit to render your app exactly as it looks in Chrome/WebKit but vector scalable and in PDF.
1;

=head1 SYNOPSIS

    package App;
    use Mojo::Base 'Mojolicious';

    sub startup {
        my $self = shift;

        $self->plugin( 'Mojolicious::Plugin::PDFRenderer', {
            javascript_delay => 1000
            , load_error_handling => 'ignore'
            , page_height => '5in'
            , page_width => '10.5in'
            # options that would otherwise be passed to PDF::WebKit,
            # see `wkhtmltopdf --extended-help` for more (replace dashes w/ underscores)
        } );
        # ...
    }

Then go to http://yourapp:3000/any/route, take a good look, then go to http://yourapp:3000/any/route.pdf. Cool, huh?

=head1 REQUIREMENTS

=over 2

=item L<PDF::WebKit>

=item L<"wkhtmltopdf"|http://wkhtmltopdf.org/>

=item A preforking server instance running (e.g. ./script/app prefork [...] or ./script/app hypnotoad [...], etc) with at least 2
connections / workers available so that the extension can hit the back-end again, i.e. a request in a request.

=back

=cut

=head1 SEE ALSO

=over 2

=item Other cool stuff I've written

=back

=cut

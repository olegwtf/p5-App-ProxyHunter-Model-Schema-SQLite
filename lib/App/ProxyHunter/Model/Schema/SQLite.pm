package App::ProxyHunter::Model::Schema::SQLite;

use Mo;
use Teng::Schema::Declare;
use DateTime;
use App::ProxyHunter::Constants;
use App::ProxyHunter::Model::SchemaUtils qw'proxy_name_to_type proxy_type_to_name';
extends 'App::ProxyHunter::Model::Schema';

our $VERSION = '0.01';

sub perl_datetime_to_sql {
	return unless defined $_[0];
	$_[0]->epoch;
}

sub sql_datetime_to_perl {
	return unless defined $_[0];
	DateTime->from_epoch(epoch => $_[0], time_zone => TZ);
}

table {
	name 'proxy';
	pk 'id';
	columns qw(
		id
		host
		port
		checked
		success_total
		fails_total
		insertdate
		checkdate
		speed_checkdate
		fails
		type
		in_progress
		conn_time
		speed
	);
	
	inflate type => \&proxy_name_to_type;
	deflate type => \&proxy_type_to_name;
	
	for (qw/insertdate checkdate speed_checkdate/) {
		inflate $_ => \&sql_datetime_to_perl;
		deflate $_ => \&perl_datetime_to_sql;
	}
};

1;

=pod

=head1 NAME

App::ProxyHunter::Schema::Model::mysql - SQLite schema for App::ProxyHunter

=head1 SYNOPSIS

	# just edit proxyhunter's config
	db = {
		driver: "SQLite"
	}

=head1 DESCRIPTION

Use C<proxyhunter --create-schema> to create database and tables structure

=head1 SEE ALSO

L<App::ProxyHunter>

=head1 AUTHOR

Oleg G, E<lt>oleg@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself

=cut

__DATA__
CREATE TABLE "proxy" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    "host" TEXT NOT NULL,
    "port" INTEGER NOT NULL,
    "checked" INTEGER NOT NULL DEFAULT (0),
    "success_total" INTEGER NOT NULL DEFAULT (0),
    "fails_total" INTEGER NOT NULL DEFAULT (0),
    "insertdate" INTEGER NOT NULL,
    "checkdate" INTEGER NOT NULL DEFAULT (0),
    "speed_checkdate" INTEGER NOT NULL DEFAULT (0),
    "fails" INTEGER NOT NULL DEFAULT (0),
    "type" TEXT NOT NULL DEFAULT ('DEAD_PROXY'),
    "in_progress" INTEGER NOT NULL DEFAULT (0),
    "conn_time" INTEGER DEFAULT ('NULL'),
    "speed" INTEGER NOT NULL DEFAULT (0)
);
CREATE UNIQUE INDEX "proxy_uniq_idx" on proxy (host ASC, port ASC);
CREATE INDEX "type_idx" on proxy (type ASC);
CREATE INDEX "sort_idx" on proxy (checked ASC, checkdate ASC);

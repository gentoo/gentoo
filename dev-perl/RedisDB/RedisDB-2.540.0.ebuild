# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ZWON
DIST_VERSION=2.54
DIST_EXAMPLES=( "eg/*" )
inherit perl-module

DESCRIPTION="Perl extension to access redis database"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test minimal"

RDEPEND="
	>=virtual/perl-Encode-2.100.0
	virtual/perl-IO-Socket-IP
	>=dev-perl/RedisDB-Parser-2.210.0
	dev-perl/Try-Tiny
	dev-perl/URI
	dev-perl/URI-redis
	>=dev-perl/Test-TCP-1.170.0
"
DEPEND="${RDEPEND}
	virtual/perl-Digest-SHA
	>=virtual/perl-ExtUtils-MakeMaker-6.300.200
	test? (
		!minimal? (
			dev-db/redis
		)
		>=dev-perl/Test-Differences-0.610.0
		dev-perl/Test-FailWarnings
		>=dev-perl/Test-Most-0.220.0
		>=virtual/perl-Test-Simple-0.960.0
	)
"
src_test() {
	if use minimal; then
		einfo "Disabling active redis-server tests (USE=minimal)"
		perl_rm_files t/basic_redis.t \
			t/auth.t \
			t/redis_commands.t \
			t/restore_subscriptions.t \
			t/send_command_cb.t \
			t/subscribe.t \
			t/transactions.t \
			t/utf8.t
	fi
	perl-module_src_test
}

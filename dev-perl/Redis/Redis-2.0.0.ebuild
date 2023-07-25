# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DAMS
DIST_TEST="do"
DIST_VERSION=2.000
inherit perl-module

DESCRIPTION="Perl bindings for Redis database"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND="
	>=dev-perl/IO-Socket-Timeout-0.290.0
	dev-perl/Try-Tiny
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-Tiny-0.34.0
	test? (
		!minimal? (
			dev-db/redis
		)
		virtual/perl-Digest-SHA
		virtual/perl-File-Spec
		virtual/perl-IO
		dev-perl/IO-String
		virtual/perl-IPC-Cmd
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-SharedFork
		>=dev-perl/Test-TCP-1.190.0
	)
"

src_test() {
	local badfiles=(
		"t/release-distmeta.t"
		"t/release-pod-coverage.t"
	)

	if use minimal; then
		einfo "Disabling Redis Server spawning tests (USE=minimal)"
		badfiles+=(
			t/01-basic.t
			t/02-responses.t
			t/03-pubsub.t
			t/04-pipeline.t
			t/05-nonblock.t
			t/06-on-connect.t
			t/07-reconnect.t
			t/08-unix-socket.t
			t/10-tie-list.t
			t/11-timeout.t
			t/20-tie-hash.t
			t/30-scripts.t
			t/42-client_cmds.t
			t/44-no-unicode-bug.t
			t/50-fork_safe.t
		)
	fi

	perl_rm_files "${badfiles[@]}"

	# https://github.com/PerlRedis/perl-redis/issues/127#issuecomment-354670681
	export REDIS_DEBUG=1

	perl-module_src_test
}

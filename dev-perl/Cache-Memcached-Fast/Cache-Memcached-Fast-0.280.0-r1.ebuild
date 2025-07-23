# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RAZ
DIST_VERSION=0.28
DIST_EXAMPLES=("script/*")
# Tests a bit flaky
DIST_TEST=do
inherit perl-module

DESCRIPTION="Perl client for memcached, in C language"

# License note: Perl 5.x or newer, + "when C parts used as standalone library"
# Bug: https://bugs.gentoo.org/718946#c4
LICENSE="|| ( Artistic GPL-1+ ) LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	>=virtual/perl-Carp-1.250.0
	>=virtual/perl-XSLoader-0.140.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test?	(
		>=virtual/perl-Test2-Suite-0.0.72
		net-misc/memcached
	)
"

PATCHES=(
	"${FILESDIR}/0.230.0-parallel-make.patch"
	# https://github.com/JRaspass/Cache-Memcached-Fast/pull/11
	"${FILESDIR}/${PN}-0.270.0-no-flto.patch"
)

PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
)

src_test() {
	ewarn "t/commands.t is known to fail: https://bugs.gentoo.org/722848"
	local memcached_opts=( -d -P "${T}/memcached.pid" -p 11211 -l 127.0.0.1 )
	[[ ${EUID} == 0 ]] && memcached_opts+=( -u portage )
	memcached "${memcached_opts[@]}" || die "Can't start memcached test server"

	local exit_status
	perl-module_src_test
	exit_status=$?

	kill "$(<"${T}/memcached.pid")"
	return ${exit_status}
}

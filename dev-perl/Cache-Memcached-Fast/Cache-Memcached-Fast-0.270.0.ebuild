# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=RAZ
DIST_VERSION=0.27
DIST_EXAMPLES=("script/*")
inherit perl-module

DESCRIPTION="Perl client for memcached, in C language"

# License note: Perl 5.x or newer, + "when C parts used as standalone library"
# Bug: https://bugs.gentoo.org/718946#c4
LICENSE="|| ( Artistic GPL-1+ ) LGPL-2.1+"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Storable"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test?	(
		net-misc/memcached
		virtual/perl-Test-Simple
	)
"

PATCHES=(
	"${FILESDIR}/0.230.0-parallel-make.patch"
	"${FILESDIR}/${PN}-0.270.0-no-flto.patch"
)

PERL_RM_FILES=(
	"t/pod-coverage.t"
	"t/pod.t"
)

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}

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

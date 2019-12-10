# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils flag-o-matic multilib autotools-multilib

DESCRIPTION="Library of simple functions that are optimized for various CPUs"
HOMEPAGE="https://liboil.freedesktop.org/"
SRC_URI="https://liboil.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0.3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+examples static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="examples? ( dev-libs/glib:2 )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig"
DOCS=( AUTHORS BUG-REPORTING HACKING NEWS README )

src_prepare() {
	if ! use examples; then
		sed "s/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/" \
			-i Makefile.am Makefile.in || die
	fi

	if ! use test; then
		sed "s/^\(SUBDIRS =.*\)testsuite\(.*\)$/\1\2/" \
			-i Makefile.am Makefile.in || die
	fi

	epatch "${FILESDIR}/${P}-amd64-cpuid.patch"
	has x32 $(get_all_abis) && epatch "${FILESDIR}"/${PN}-0.3.17-x32.patch
}

src_configure() {
	strip-flags
	filter-flags -O?
	append-flags -O2

	# For use with Clang, which is the only compiler on OSX, bug #576646
	[[ ${CHOST} == *-darwin* ]] && append-flags -fheinous-gnu-extensions

	autotools-multilib_src_configure
}

pkg_postinst() {
	if ! use examples; then
		ewarn "You have disabled examples USE flag. Beware that upstream might"
		ewarn "want the output of some utilities that are only built with"
		ewarn "USE='examples' if you report bugs to them."
	fi
}

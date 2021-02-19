# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

DESCRIPTION="Library of simple functions that are optimized for various CPUs"
HOMEPAGE="https://liboil.freedesktop.org/"
SRC_URI="https://liboil.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0.3"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+examples test"
RESTRICT="!test? ( test )"

RDEPEND="examples? ( dev-libs/glib:2 )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gtk-doc-am
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-amd64-cpuid.patch )

src_prepare() {
	has x32 $(get_all_abis) && PATCHES+=( "${FILESDIR}"/${PN}-0.3.17-x32.patch )
	default

	if ! use examples; then
		sed "s/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/" \
			-i Makefile.in || die
	fi

	if ! use test; then
		sed "s/^\(SUBDIRS =.*\)testsuite\(.*\)$/\1\2/" \
			-i Makefile.in || die
	fi
}

src_configure() {
	strip-flags
	filter-flags -O?
	append-flags -O2

	# For use with Clang, which is the only compiler on OSX, bug #576646
	[[ ${CHOST} == *-darwin* ]] && append-flags -fheinous-gnu-extensions

	multilib_src_configure() {
		ECONF_SOURCE="${S}" econf --disable-static
	}
	multilib-minimal_src_configure
}

multilib_src_install_all() {
	einstalldocs
	dodoc BUG-REPORTING HACKING

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if ! use examples; then
		ewarn "You have disabled examples USE flag. Beware that upstream might"
		ewarn "want the output of some utilities that are only built with"
		ewarn "USE='examples' if you report bugs to them."
	fi
}

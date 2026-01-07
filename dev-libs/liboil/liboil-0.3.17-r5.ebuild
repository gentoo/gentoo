# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Library of simple functions that are optimized for various CPUs"
HOMEPAGE="https://liboil.freedesktop.org/"
SRC_URI="https://liboil.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0.3"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="+examples test"
RESTRICT="!test? ( test )"

RDEPEND="examples? ( dev-libs/glib:2 )"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/gtk-doc-am
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-amd64-cpuid.patch
	"${FILESDIR}"/${P}-c99-configure.patch
)

src_prepare() {
	[[ ${CHOST} == *x32 ]] && PATCHES+=( "${FILESDIR}"/${PN}-0.3.17-x32.patch )

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
	# bug #931004
	filter-lto

	# bug #576646
	tc-is-clang && append-flags -fheinous-gnu-extensions

	default
}

src_install() {
	default

	dodoc BUG-REPORTING HACKING

	# No static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	if ! use examples; then
		ewarn "You have disabled examples USE flag. Beware that upstream might"
		ewarn "want the output of some utilities that are only built with"
		ewarn "USE='examples' if you report bugs to them."
	fi
}

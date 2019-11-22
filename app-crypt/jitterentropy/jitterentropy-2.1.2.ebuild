# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Hardware RNG based on CPU timing jitter"
HOMEPAGE="https://github.com/smuellerDD/jitterentropy-library"
SRC_URI="https://github.com/smuellerDD/jitterentropy-library/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 ~riscv x86"
IUSE="static-libs"

S="${WORKDIR}/${PN}-library-${PV}"

src_prepare() {
	default

	# Disable man page compression on install
	sed -e '/\tgzip.*man/ d' -i Makefile || die
	# Let the package manager handle stripping
	sed -e '/\tinstall.*-s / s/-s //g' -i Makefile || die
}

src_compile() {
	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/include # See: https://github.com/smuellerDD/jitterentropy-library/pull/9
	emake PREFIX="${EPREFIX}/usr" \
		  LIBDIR="$(get_libdir)" \
		  DESTDIR="${D}" install
	use static-libs && dolib.a lib${PN}.a
}

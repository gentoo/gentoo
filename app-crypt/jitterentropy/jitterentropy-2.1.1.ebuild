# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Hardware RNG based on CPU timing jitter"
HOMEPAGE="https://github.com/smuellerDD/jitterentropy-library"
SRC_URI="https://github.com/gktrk/jitterentropy-library/archive/v2.1.1.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.1-destdir-fix.patch
)

S="${WORKDIR}/${PN}-library-${PV}"

src_prepare() {
	default

	# Disable man page compression on install
	sed -e '/\tgzip.*man/ d' -i Makefile || die
	# Let the package manager handle stripping
	sed -e '/\tinstall.*-s / s/-s //g' -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" \
		  LIBDIR="$(get_libdir)" \
		  DESTDIR="${D}" install
	dosym lib${PN}.so.${PV} "/usr/$(get_libdir)"/lib${PN}.so
	doheader ${PN}.h ${PN}-base-user.h
}

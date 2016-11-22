# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="User Interface for TuxOnIce"
HOMEPAGE="http://tuxonice.nigelcunningham.com.au/ https://github.com/NigelCunningham/Tuxonice-Userui"
SRC_URI="http://tuxonice.net/files/${P}.tar.gz -> ${P}.tar
	mirror://debian/pool/main/t/${PN}/${PN}_${PV}-2~exp1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="fbsplash"

DEPEND="fbsplash? (
		media-libs/freetype:2=
		media-libs/libmng:0=
		media-libs/libpng:0=
		virtual/jpeg:0=
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	local d=${WORKDIR}/debian/patches
	EPATCH_SOURCE=${d} epatch $(<"${d}"/series)
	epatch "${FILESDIR}"/${P}-freetype-2.5.patch
	sed -i -e 's/make/$(MAKE)/' Makefile || die
	sed -i -e 's/ -O3//' Makefile fbsplash/Makefile usplash/Makefile || die
}

src_compile() {
	# Package contain binaries
	emake clean

	use fbsplash && export USE_FBSPLASH=1
	emake CC="$(tc-getCC)" tuxoniceui
}

src_install() {
	into /
	dosbin tuxoniceui
	dodoc AUTHORS ChangeLog KERNEL_API README TODO USERUI_API
}

pkg_postinst() {
	if use fbsplash; then
		einfo
		elog "You must create a symlink from /etc/splash/tuxonice"
		elog "to the theme you want tuxonice to use, e.g.:"
		elog
		elog "  # ln -sfn /etc/splash/emergence /etc/splash/tuxonice"
	fi
	einfo
	einfo "Please see /usr/share/doc/${PF}/README.* for further"
	einfo "instructions."
	einfo
}

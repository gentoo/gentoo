# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="User Interface for TuxOnIce"
HOMEPAGE="http://www.tuxonice.net"
SRC_URI="http://tuxonice.net/files/${P}.tar.gz -> ${P}.tar
	mirror://debian/pool/main/t/${PN}/${PN}_${PV}-2~exp1.debian.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="fbsplash"

DEPEND="fbsplash? (
		>=app-arch/bzip2-1.0.6-r3[static-libs]
		>=media-gfx/splashutils-1.5.2.1
		media-libs/freetype[static-libs]
		media-libs/libmng
		>=media-libs/libpng-1.4.8[static-libs]
		virtual/jpeg
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
		if [[ ${REPLACING_VERSIONS} < 1.1 ]]; then
			einfo
			elog "You must refer to '/sbin/tuxoniceui -f' instead of /sbin/tuxoniceui_fbsplash'"
			elog "in all places you set it."
		fi
	fi
	einfo
	einfo "Please see /usr/share/doc/${PF}/README.* for further"
	einfo "instructions."
	einfo
}

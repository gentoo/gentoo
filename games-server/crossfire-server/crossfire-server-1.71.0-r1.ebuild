# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P/-server/}"
DESCRIPTION="Server for the crossfire clients"
HOMEPAGE="http://crossfire.real-time.com/"
SRC_URI="mirror://sourceforge/crossfire/${PN}/${PV}/${MY_P}.tar.bz2
	mirror://sourceforge/crossfire/${PN}/${PV}/${MY_P}.maps.tar.bz2
	mirror://sourceforge/crossfire/${PN}/${PV}/${MY_P}.arch.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"
RESTRICT="test"

RDEPEND="
	net-misc/curl
	X? (
		x11-libs/libXaw
		media-libs/libpng:0=
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	rm -f "${WORKDIR}"/maps/Info/combine.pl # bug #236205
	ln -s "${WORKDIR}/arch" "${S}/lib" || die
	eapply "${FILESDIR}"/${P}-format.patch
}

src_configure() {
	econf --disable-static
}

src_compile() {
	# work around the collect.pl locking
	emake -j1 -C lib
	emake
}

src_install() {
	default
	keepdir /var/lib/crossfire/{account,datafiles,maps,players,template-maps,unique-items}
	insinto /usr/share/crossfire
	doins -r "${WORKDIR}/maps"
	find "${D}" -name '*.la' -delete || die
}

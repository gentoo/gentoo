# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_P=${P/_/-}

DESCRIPTION="Basic AX.25 (Amateur Radio) administrative tools and daemons"
HOMEPAGE="http://www.linux-ax25.org/"
SRC_URI="http://www.linux-ax25.org/pub/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

DOCS=(  AUTHORS ChangeLog NEWS README tcpip/ttylinkd.README \
		user_call/README.user_call yamdrv/README.yamdrv dmascc/README.dmascc \
		tcpip/ttylinkd.INSTALL )

S=${WORKDIR}/${MY_P}

DEPEND="
	dev-libs/libax25
	X? (
		x11-libs/libX11
		media-libs/mesa[X(+)]
	)"
RDEPEND=${DEPEND}

src_configure() {
	econf $(use_with X x)
}

src_install() {
	emake DESTDIR="${D}" install installconf
	einstalldocs

	newinitd "${FILESDIR}"/ax25d.rc ax25d
	newinitd "${FILESDIR}"/mheardd.rc mheardd
	newinitd "${FILESDIR}"/netromd.rc netromd
	newinitd "${FILESDIR}"/rip98d.rc rip98d
	newinitd "${FILESDIR}"/rxecho.rc rxecho
	newinitd "${FILESDIR}"/ttylinkd.rc ttylinkd
}

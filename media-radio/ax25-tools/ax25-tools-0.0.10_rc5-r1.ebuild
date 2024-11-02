# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_P=${P/_/-}

DESCRIPTION="Basic AX.25 (Amateur Radio) administrative tools and daemons"
HOMEPAGE="
	https://linux-ax25.in-berlin.de/
	https://packet-radio.net/ax-25/
" # NOTE: ...in-berlin.de does not work but subdomains do
SRC_URI="
	https://linux-ax25.in-berlin.de/pub/${PN}/${MY_P}.tar.gz
	https://ham.packet-radio.net/packet/ax25/ax25-apps/${MY_P}.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="X"

DOCS=(  AUTHORS ChangeLog NEWS README tcpip/ttylinkd.README \
		user_call/README.user_call yamdrv/README.yamdrv dmascc/README.dmascc \
		tcpip/ttylinkd.INSTALL )

DEPEND="
	dev-libs/libax25
	X? (
		x11-libs/libX11
		media-libs/mesa[X(+)]
	)"
RDEPEND="${DEPEND}
	sys-libs/zlib"

src_prepare() {
	if use elibc_musl ; then
		eapply -p1 "${FILESDIR}/${PN}-0.0.10-musl.patch"
	fi
	eapply -p1 "${FILESDIR}/${PN}-0.0.10-fix-pointer-types.patch"
	eapply_user
}

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

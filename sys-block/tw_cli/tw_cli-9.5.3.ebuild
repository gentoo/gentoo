# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="3ware SATA+PATA RAID controller Command Line Interface tool"
HOMEPAGE="https://www.3ware.com/3warekb/article.aspx?id=14847"
LICENSE="3ware"
SLOT="0"
# binary packages
KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
IUSE=""
# stripping seems to break this sometimes
RESTRICT="strip"
# binary packages
DEPEND=""
RDEPEND=""

# Upstream has _FUN_ naming these
# We are mostly prepared for the FreeBSD binaries at this point
# They just aren't yet enabled here
PN_KERNEL="${ARCH/*fbsd-*/freebsd}"
[ "${PN_KERNEL}" != 'freebsd' ] && PN_KERNEL='linux'
PN_ARCH="${ARCH/*-}"
PN_ARCH="${PN_ARCH/amd64/x86_64}"

# The naming of <=9.5.0 for freebsd was weird,
# but 9.5.0.1 has it sanely.
MY_P="${PN}-${PN_KERNEL}-${PN_ARCH}-${PV}"

# Upstream actually only releases newer versions for new hardware
# and doesn't release new major versions for old hardware
# however their backwards compatibility is excellent.
# I personally test tw_cli on 4 cards:
# 7006-2 on x86.
# 9500S-8 on amd64.
# 9500S-4LP on amd64.
# 9650SE-8LPML on amd64.
# - Robin H. Johnson <robbat2@gentoo.org> - 23 Nov 2006
#HW_VARIANT="Escalade7000Series" - for versions 9.3.0.*
#HW_VARIANT="Escalade9650SE-Series" # for versions 9.4.0*
HW_VARIANT="Escalade9690SA-Series" # for versions 9.5.0*
# package has different tarballs for x86 and amd64
SRC_URI_BASE="http://www.3ware.com/download/${HW_VARIANT}/${PV}"
SRC_URI_x86="${SRC_URI_BASE}/${PN}-linux-x86-${PV}.tgz"
SRC_URI_amd64="${SRC_URI_BASE}/${PN}-linux-x86_64-${PV}.tgz"
SRC_URI_x86_fbsd="${SRC_URI_BASE}/${PN}-freebsd-x86-${PV}.tgz"
#SRC_URI_amd64_fbsd="${SRC_URI_BASE}/${PN}-x86_64-freebsd-${PV}.tgz"
SRC_URI="x86?   ( ${SRC_URI_x86} )
		 amd64? ( ${SRC_URI_amd64} )
		 x86-fbsd? ( ${SRC_URI_x86_fbsd} )"
		#amd64-fbsd? ( ${SRC_URI_amd64_fbsd} )
LICENSE_URL="http://www.3ware.com/support/windows_agree.asp?path=/download/${HW_VARIANT}/${PV}/${MY_P}.tgz"

S="${WORKDIR}"

src_unpack() {
	unpack ${MY_P}.tgz
}

supportedcards() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "PATA: 6xxx, 72xx, 74xx, 78xx, 7000, 7500, 7506"
	elog "SATA: 8006, 8500, 8506, 9500S, 9550SX, 9590SE,"
	elog "      9550SXU, 9650SE, 9650SE-{24M8,4LPME},"
	elog "      9690SA"
	elog ""
	elog "Release notes for this version are available at:"
	elog "${SRC_URI_BASE}/${PV}_Release_Notes_Web.pdf"
}

pkg_setup() {
	supportedcards
}

pkg_nofetch() {
	einfo "3ware would like you to agree to the license:"
	einfo ""
	einfo "\t${LICENSE_URL}"
	einfo ""
	einfo "And then use the following URL to download the"
	einfo "correct tarballs manually into ${DISTDIR}"
	einfo ""
	einfo "x86 - ${SRC_URI_x86}"
	einfo "amd64 - ${SRC_URI_amd64}"
	einfo "x86-fbsd - ${SRC_URI_x86_fbsd}"
	#einfo "amd64-fbsd - ${SRC_URI_amd64_fbsd}"
	einfo ""
	einfo "However, they have given permission to redistribute."
	einfo "https://bugs.gentoo.org/show_bug.cgi?id=60690#c106"
	einfo ""
	supportedcards
}

src_install() {
	into /
	dosbin tw_cli
	into /usr
	newman tw_cli.8.nroff tw_cli.8
	dohtml *.html
}

# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/tw_cli/tw_cli-10.1.ebuild,v 1.3 2011/08/05 21:28:38 mattst88 Exp $

DESCRIPTION="3ware SATA+PATA RAID controller Command Line Interface tool"
HOMEPAGE="https://www.3ware.com/3warekb/article.aspx?id=14847"
LICENSE="3ware"
SLOT="0"
# binary packages
KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
IUSE=""
# stripping seems to break this sometimes
RESTRICT="strip fetch"
# binary packages
DEPEND="app-arch/unzip"
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
MY_P="cli_${PN_KERNEL}_${PV}"

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
#HW_VARIANT="Escalade9690SA-Series" # for versions 9.5.0*
HW_VARIANT="3ware%20SAS%209750-8i%20Gentoo"
# package has different tarballs for x86 and amd64
SRC_URI_BASE="http://www.lsi.com/DistributionSystem/AssetDocument"
SRC_URI_linux="${SRC_URI_BASE}/cli_linux_${PV}.zip"
SRC_URI_fbsd="${SRC_URI_BASE}/cli_freebsd_${PV}.zip"
SRC_URI="kernel_linux?   ( ${SRC_URI_linux} )
		 kernel_FreeBSD? ( ${SRC_URI_fbsd} )"
		#amd64-fbsd? ( ${SRC_URI_amd64_fbsd} )
SRC_URI_mine="${SRC_URI_BASE}/cli_${PN_KERNEL}_${PV}.zip"
LICENSE_URL="http://www.lsi.com/lookup/License.aspx?url=${SRC_URI_mine}&prodName=${HW_VARIANT}&subType=Binary&locale="

S="${WORKDIR}"

src_unpack() {
	unpack ${MY_P}.zip
}

supportedcards() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "PATA: 6xxx, 72xx, 74xx, 78xx, 7000, 7500, 7506"
	elog "SATA: 8006, 8500, 8506, 9500S, 9550SX, 9590SE,"
	elog "      9550SXU, 9650SE, 9650SE-{24M8,4LPME},"
	elog "      9690SA, 9750"
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
	einfo "Linux - ${SRC_URI_linux}"
	einfo "FreeBSD - ${SRC_URI_fbsd}"
	einfo ""
	einfo "However, they have given permission to redistribute."
	einfo "http://bugs.gentoo.org/show_bug.cgi?id=60690#c106"
	einfo ""
	supportedcards
}

src_install() {
	into /
	dosbin ${PN_ARCH}/tw_cli
	into /usr
	newman tw_cli.8.nroff tw_cli.8
	dohtml *.html
}

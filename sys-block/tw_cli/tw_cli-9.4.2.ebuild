# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/tw_cli/tw_cli-9.4.2.ebuild,v 1.5 2011/08/05 21:28:38 mattst88 Exp $

DESCRIPTION="3ware SATA+PATA RAID controller Command Line Interface tool"
HOMEPAGE="https://www.3ware.com/3warekb/article.aspx?id=14847"
LICENSE="3ware"
SLOT="0"
# binary packages
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
# stripping seems to break this sometimes
RESTRICT="fetch strip mirror"
# binary packages
DEPEND=""
RDEPEND=""
MY_P="${PN}-linux-${ARCH/amd64/x86_64}-${PV}"
# Upstream actually only releases newer versions for new hardware
# and doesn't release new major versions for old hardware
# however their backwards compatibility is excellent.
# I personally test tw_cli on two cards: 6200 (amd64) and 7006-2 (x86)
# - Robin H. Johnson <robbat2@gentoo.org> - 23 Nov 2006
#HW_VARIANT="Escalade7000Series" - for versions 9.3.0.*
HW_VARIANT="Escalade9650SE-Series" # for versions 9.4.0*
# package has different tarballs for x86 and amd64
SRC_URI_BASE="http://www.3ware.com/download/${HW_VARIANT}/${PV}"
SRC_URI=""
for i in x86 amd64 ; do
	SRC_URI="${SRC_URI} ${i}? ( ${SRC_URI_BASE}/${PN}-linux-${i/amd64/x86_64}-${PV}.tgz )"
done
LICENSE_URL="http://www.3ware.com/support/windows_agree.asp?path=/download/${HW_VARIANT}/${PV}/${MY_P}.tgz"
S="${WORKDIR}/${PN}-linux-${ARCH/amd64/x86_64}-${PV}"

src_unpack() {
	unpack ${MY_P}.tgz
}

supportedcards() {
	elog "This binary supports should support ALL cards, including, but not"
	elog "limited to the following series:"
	elog ""
	elog "PATA: 6xxx, 72xx, 74xx, 78xx, 7000, 7500, 7506"
	elog "SATA: 8006, 8500, 8506, 9500S, 9550SX, 9590SE,"
	elog "      9550SXU, 9650SE, 9650SE-{24M8,4LPME}"
	elog ""
	elog "Release notes for this version are available at:"
	elog "${SRC_URI_BASE}/${PV}_Release_Notes_Web.pdf"
}

pkg_setup() {
	supportedcards
}

pkg_nofetch() {
	einfo "Please agree to the license at URL"
	einfo ""
	einfo "\t${LICENSE_URL}"
	einfo ""
	einfo "And then use the following URL to download the"
	einfo "correct tarball into ${DISTDIR}"
	einfo ""
	einfo "x86 - ${SRC_URI_x86}"
	einfo "amd64 - ${SRC_URI_amd64}"
	einfo ""
	supportedcards
}

src_install() {
	into /
	dosbin tw_cli
	dosbin tw_sched
	insinto /etc
	doins tw_sched.cfg
	into /usr
	newman tw_cli.8.nroff tw_cli.8
	newman tw_sched.8.nroff tw_sched.8
	dohtml *.html
}

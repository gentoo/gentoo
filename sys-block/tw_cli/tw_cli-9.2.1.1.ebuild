# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#set
DESCRIPTION="3ware Command Line Interface Tool"
HOMEPAGE="http://www.3ware.com/"
LICENSE="3ware"
SLOT="0"
# binary packages
KEYWORDS="-* x86 amd64"
IUSE=""
# stripping seems to break this sometimes
RESTRICT="fetch strip mirror"
# binary packages
DEPEND=""
RDEPEND=""
#DOWNLOAD_URL_BASE="http://www.3ware.com/support/download_${PV}.asp?SNO="
#DOWNLOAD_URL="x86? (   ${DOWNLOAD_URL_BASE}499 )
#			  amd64? ( ${DOWNLOAD_URL_BASE}501 )"
MY_P="${PN}-linux-${ARCH/amd64/x86_64}-${PV}"
SRC_URI_BASE="http://www.3ware.com/download/Escalade9000Series/${PV}/${PN}-linux-"
SRC_URI_X86="${SRC_URI_BASE}x86-${PV}.tgz"
SRC_URI_AMD64="${SRC_URI_BASE}x86_64-${PV}.tgz"
SRC_URI="x86? ( ${SRC_URI_X86} )
		 amd64? ( ${SRC_URI_AMD64} )"
DOWNLOAD_URL_APP="http://www.3ware.com/support/dnload_agreeeng.asp?code=2&id=&softtype=CLI&os=Linux"

#S="${WORKDIR}/${MY_P}"
S="${WORKDIR}"

src_unpack() {
	unpack ${MY_P}.tgz
}

supportedcards() {
	einfo "This binary supports all current cards, including, but not"
	einfo "limited to:"
	einfo "PATA: 7210, 7410, 7450, 7810, 7850, 7000-2, 7500-4, 7500-8,"
	einfo "      7500-12, 7006-2, 7506-4, 7506-4LP, 7506-8, 7506-12"
	einfo "SATA: 8500-4, 8500-8, 8500-12, 8006-2, 8506-4, 8506-12,"
	einfo "      8506-8MI, 8506-12MI, 9500S-4LP, 9500S-8, 9500S-12,"
	einfo "      9500S-8MI, 9500S-12MI"
}

pkg_setup() {
	supportedcards
}

pkg_nofetch() {
	einfo "Please agree to the license at"
	einfo "${DOWNLOAD_URL_APP}"
	einfo "And then use one of the following URLs to download the"
	einfo "correct tarball into ${DISTDIR}"
	einfo "amd64: ${SRC_URI_AMD64}"
	einfo "x86: ${SRC_URI_X86}"
	einfo "Download the 32-bit version for x86 machines, or the"
	einfo "64-bit version for amd64 machines."
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

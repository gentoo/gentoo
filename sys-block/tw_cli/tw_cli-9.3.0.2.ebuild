# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="3ware SATA+PATA RAID controller Command Line Interface tool"
HOMEPAGE="http://www.3ware.com/"
LICENSE="3ware"
SLOT="0"
# binary packages
KEYWORDS="-* ~x86 ~amd64"
IUSE=""
# stripping seems to break this sometimes
RESTRICT="fetch strip mirror"
# binary packages
DEPEND=""
RDEPEND=""
MY_P="${PN}-linux-${ARCH/amd64/x86_64}-${PV}"
# package has different tarballs for x86 and amd64
SRC_URI_BASE="http://www.3ware.com/download/Escalade9000Series/${PV}"
SRC_URI="x86? ( ${SRC_URI_BASE}/${PN}-linux-x86-${PV}.tgz )
		 amd64? ( ${SRC_URI_BASE}/${PN}-linux-x86_64-${PV}.tgz )"
# x86: http://3ware.com/support/download_9.3.0.2.asp?SNO=616
# amd64: http://3ware.com/support/download_9.3.0.2.asp?SNO=617
DOWNLOAD_URL="http://www.3ware.com/support/windows_agree.asp?path=/download/Escalade9000Series/${PV}/${MY_P}.tgz"
S="${WORKDIR}"

src_unpack() {
	unpack ${MY_P}.tgz
}

supportedcards() {
	einfo "This binary supports all current cards, including, but not"
	einfo "limited to:"
	einfo ""
	einfo "PATA: 7210, 7410, 7450, 7810, 7850, 7000-2, 7500-4, 7500-8,"
	einfo "      7500-12, 7006-2, 7506-4, 7506-4LP, 7506-8, 7506-12"
	einfo ""
	einfo "SATA: 8500-4, 8500-8, 8500-12, 8006-2, 8506-4, 8506-12,"
	einfo "      8506-8MI, 8506-12MI, 9500S-4LP, 9500S-8, 9500S-12,"
	einfo "      9500S-8MI, 9500S-12MI"
}

pkg_setup() {
	supportedcards
}

pkg_nofetch() {
	einfo "Please agree to the license at URL"
	einfo ""
	einfo "\t${DOWNLOAD_URL}"
	einfo ""
	einfo "And then use the following URL to download the"
	einfo "correct tarball into ${DISTDIR}"
	einfo ""
	einfo "\t${SRC_URI}"
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

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/arpwatch/arpwatch-2.1.15-r7.ebuild,v 1.1 2014/09/24 13:01:51 jer Exp $

EAPI=5
inherit eutils user versionator

PATCH_VER="0.6"

MY_P="${PN}-$(replace_version_separator 2 'a')"
DESCRIPTION="An ethernet monitor program that keeps track of ethernet/ip address pairings"
HOMEPAGE="http://ee.lbl.gov/"
SRC_URI="
	ftp://ftp.ee.lbl.gov/${MY_P}.tar.gz
	https://dev.gentoo.org/~jer/arpwatch-patchset-${PATCH_VER}.tbz2
"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="selinux"

DEPEND="
	net-libs/libpcap
	sys-libs/ncurses
"

RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-arpwatch )
"

S=${WORKDIR}/${MY_P}

pkg_preinst() {
	enewuser arpwatch
}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}"/arpwatch-patchset/ EPATCH_SUFFIX="patch" epatch
	cp "${WORKDIR}"/arpwatch-patchset/*.8 . || die
}

src_install () {
	dosbin arpwatch arpsnmp arp2ethers massagevendor arpfetch bihourly.sh
	doman arpwatch.8 arpsnmp.8 arp2ethers.8 massagevendor.8 arpfetch.8 bihourly.8

	insinto /usr/share/arpwatch
	doins ethercodes.dat

	insinto /usr/share/arpwatch/awk
	doins duplicates.awk euppertolower.awk p.awk e.awk d.awk

	keepdir /var/lib/arpwatch
	dodoc README CHANGES

	newinitd "${FILESDIR}"/arpwatch.initd arpwatch
	newconfd "${FILESDIR}"/arpwatch.confd arpwatch
}

pkg_postinst() {
	fowners arpwatch:0 "${ROOT}"/var/lib/arpwatch
}

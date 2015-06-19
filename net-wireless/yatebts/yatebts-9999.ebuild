# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/yatebts/yatebts-9999.ebuild,v 1.9 2015/02/16 16:44:06 zerochaos Exp $

EAPI=5

inherit eutils autotools

DESCRIPTION="The Yate GSM base station"
HOMEPAGE="http://www.yatebts.com/"
ESVN_REPO_URI="http://voip.null.ro/svn/yatebts/trunk"

LICENSE="GPL-2"
SLOT="0"
IUSE="rad1 usrp1 uhd +bladerf cpu_flags_x86_sse3 cpu_flags_x86_sse4_1"

RDEPEND="
	=net-voip/yate-${PV}:=[gsm]
	bladerf? ( net-wireless/bladerf:= )
	uhd? ( net-wireless/uhd )
	virtual/libusb:1"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

if [[ ${PV} == "9999" ]] ; then
	inherit subversion
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~arm ~x86"
	SRC_URI="http://yate.null.ro/tarballs/${PN}4/yate-bts-${PV}-1.tar.gz"
	S="${WORKDIR}/yate-bts"
fi

src_prepare() {
	#we need more patches or configure flags because things install in really wrong places per FHS
	epatch "${FILESDIR}"/${PN}-sgsnggsn-inetutils-hostname-fix.diff
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable rad1) \
		$(use_enable usrp1) \
		$(use_enable uhd) \
		$(use_enable bladerf) \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41)

}

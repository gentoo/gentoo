# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The Yate GSM base station"
HOMEPAGE="https://yatebts.com"
ESVN_REPO_URI="http://voip.null.ro/svn/yatebts/trunk"

LICENSE="GPL-2"
SLOT="0"
IUSE="rad1 usrp1 uhd +bladerf cpu_flags_x86_sse3 cpu_flags_x86_sse4_1"

RDEPEND="
	>=net-voip/yate-6.0.0:=[gsm]
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
	SRC_URI="http://yate.null.ro/tarballs/${PN}6/yate-bts-${PV}-1.tar.gz"
	S="${WORKDIR}/yate-bts"
fi

#we need more patches or configure flags because things install in really wrong places per FHS
PATCHES=(
	"${FILESDIR}"/${PN}-sgsnggsn-inetutils-hostname-fix.diff
	"${FILESDIR}"/${PN}-5.0.0-gcc6.patch
	"${FILESDIR}"/${P}-dont-mess-with-cflags.patch
	)

src_prepare() {
	default
	eautoreconf
}

#		$(use_enable rad1) \
#		$(use_enable usrp1) \
#		$(use_enable uhd) \
#		$(use_enable bladerf) \
src_configure() {
	econf \
		$(use_enable cpu_flags_x86_sse3 sse3) \
		$(use_enable cpu_flags_x86_sse4_1 sse41)

}

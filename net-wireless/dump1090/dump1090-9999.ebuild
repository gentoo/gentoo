# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs eutils

DESCRIPTION="simple Mode S decoder for RTLSDR devices"
#Original repo
#HOMEPAGE="https://github.com/antirez/dump1090"
#Repo that has actually been touched recenly
#HOMEPAGE="https://github.com/mutability/dump1090"
#And now we move to the next one in line
HOMEPAGE="https://github.com/flightaware/dump1090"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flightaware/${PN}.git"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	#COMMIT="fb5942dba6505a21cbafc7905a5a7c513b214dc9"
	#SRC_URI="https://github.com/flightaware/dump1090/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	#S="${WORKDIR}/${PN}-${COMMIT}"
	SRC_URI="https://github.com/flightaware/dump1090/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
IUSE="bladerf +rtlsdr"

RDEPEND="bladerf? ( net-wireless/bladerf:= )
		rtlsdr? ( net-wireless/rtl-sdr:= )
		sys-libs/ncurses:=
		virtual/libusb:1"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i 's#-O2 -g -Wall -Werror -W##' Makefile
	sed -i "s#-lncurses#$($(tc-getPKG_CONFIG) --libs ncurses)#" Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" \
		BLADERF=$(usex bladerf) \
		RTLSDR=$(usex rtlsdr)
}

src_install() {
	dobin ${PN}
	dobin view1090
	dodoc README.md

	insinto /usr/share/${PN}/html
	doins -r public_html/*

	insinto /usr/share/${PN}/tools
	doins -r tools/*

	insinto /usr/share/${PN}
	newins debian/lighttpd/89-dump1090-fa.conf lighttpd.conf
}

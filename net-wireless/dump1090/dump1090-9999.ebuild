# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="simple Mode S decoder for RTLSDR devices"
HOMEPAGE="https://github.com/flightaware/dump1090"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flightaware/${PN}.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/flightaware/dump1090/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
IUSE="bladerf +rtlsdr"

DEPEND="
	sys-libs/ncurses:=[tinfo]
	virtual/libusb:1
	bladerf? ( net-wireless/bladerf:= )
	rtlsdr? ( net-wireless/rtl-sdr:= )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e 's#-O2 -g -Wall -Werror -W##' Makefile || die
	sed -i -e "s#-lncurses#$($(tc-getPKG_CONFIG) --libs ncurses)#" Makefile || die
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

	insinto /usr/share/${PN}
	doins -r tools

	insinto /usr/share/${PN}
	newins debian/lighttpd/89-dump1090-fa.conf lighttpd.conf
}

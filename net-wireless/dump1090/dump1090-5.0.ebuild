# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit tmpfiles toolchain-funcs

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
IUSE="bladerf hackrf +rtlsdr minimal"

DEPEND="
	sys-libs/ncurses:=[tinfo]
	bladerf? ( net-wireless/bladerf:= virtual/libusb:1 )
	hackrf? ( net-libs/libhackrf:= virtual/libusb:1 )
	rtlsdr? ( net-wireless/rtl-sdr:= virtual/libusb:1 )"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e '/CFLAGS/s# -O3 -g -Wall -Wmissing-declarations -Werror -W # #' Makefile || die
	sed -i -e "/LIBS_CURSES/s#-lncurses#$($(tc-getPKG_CONFIG) --libs ncurses)#" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" \
		BLADERF=$(usex bladerf) \
		RTLSDR=$(usex rtlsdr) \
		HACKRF=$(usex hackrf) \
		CPUFEATURES=yes \
		LIMESDR=no
}

src_install() {
	dobin ${PN}
	dobin view1090
	dodoc README.md README-json.md
	# DSP config for bladerf
	if use bladerf; then
		insinto usr/share/${PN}/bladerf
		doins bladerf/*
	fi

	newtmpfiles "${FILESDIR}"/tmpfilesd-dump1090-5.0.conf ${PN}.conf
	newconfd "${FILESDIR}"/dump1090-5.0.confd ${PN}
	newinitd "${FILESDIR}"/dump1090-5.0.initd ${PN}

	if use !minimal; then
		insinto /usr/share/${PN}
		doins -r tools

		# Some tooling expects the -fa variant directory to contain the files
		dosym ../../usr/share/${PN} /usr/share/dump1090-fa

		# Older HTML
		insinto /usr/share/${PN}/html
		doins -r public_html/*
		# Newer HTML
		insinto /usr/share/skyaware/html
		doins -r public_html_merged/*

		# One of these this should be included into other lighttpd configs
		insinto /usr/share/${PN}/lighttpd
		# Old style:
		doins debian/lighttpd/89-dump1090-fa.conf
		doins debian/lighttpd/88-dump1090-fa-statcache.conf
		# New style:
		doins debian/lighttpd/89-skyaware.conf

		# See README.md for how to use custom wisdom files
		exeinto /usr/share/${PN}/wisdom
		doexe debian/generate-wisdom
		insinto /usr/share/${PN}/wisdom
		doins wisdom.*
		doins wisdom/wisdom.*
		# For /etc/dump1090-fa/wisdom.local
		keepdir /etc/dump1090-fa/

		# Tooling to generate custom wisdom:
		exeinto /usr/libexec/${PN}
		doexe starch-benchmark
	fi
}

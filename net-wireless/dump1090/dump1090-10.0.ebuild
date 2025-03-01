# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles toolchain-funcs

DESCRIPTION="Simple Mode S decoder for RTLSDR devices"
HOMEPAGE="https://github.com/flightaware/dump1090"

if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/flightaware/${PN}.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/flightaware/dump1090/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD GPL-2+"
SLOT="0"
IUSE="bladerf hackrf minimal +rtlsdr"

DEPEND="
	sys-libs/ncurses:=[tinfo]
	bladerf? (
		net-wireless/bladerf:=
		virtual/libusb:1
	)
	hackrf? (
		net-libs/libhackrf:=
		virtual/libusb:1
	)
	rtlsdr? (
		net-wireless/rtl-sdr:=
		virtual/libusb:1
	)
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-6.1-libdir.patch )

src_prepare() {
	default

	sed \
		-e '/CFLAGS/s/-Werror//g' \
		-e "/LIBS_CURSES/s|-lncurses|$($(tc-getPKG_CONFIG) --libs ncurses)|g" \
		-i Makefile || die
}

src_compile() {
	myemakeargs=(
		BLADERF="$(usex bladerf)"
		CC="$(tc-getCC)"
		CPUFEATURES="yes"
		HACKRF="$(usex hackrf)"
		LIMESDR="no"
		RTLSDR="$(usex rtlsdr)"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	dobin dump1090 view1090

	# DSP config files for bladeRF
	if use bladerf; then
		insinto usr/share/dump1090/bladerf
		doins bladerf/*
	fi

	newtmpfiles "${FILESDIR}"/tmpfilesd-dump1090-5.0.conf dump1090.conf
	newconfd "${FILESDIR}"/dump1090-5.0.confd dump1090
	newinitd "${FILESDIR}"/dump1090-5.0.initd dump1090

	einstalldocs

	if use !minimal; then
		# Install tools
		insinto /usr/share/dump1090
		doins -r tools

		# Install lighthttps example files
		insinto /usr/share/dump1090/lighttpd
		doins debian/lighttpd/{88-dump1090-fa-statcache.conf,89-skyaware.conf}

		# Some tooling expects the -fa variant directory to contain the files
		dosym ../../usr/share/dump1090 /usr/share/dump1090-fa

		# Install html docs
		docinto html
		doins -r public_html/*

		# See README.md for how to use custom wisdom files
		exeinto /usr/share/dump1090/wisdom
		doexe debian/generate-wisdom
		insinto /usr/share/dump1090/wisdom
		doins wisdom.*
		doins wisdom/wisdom.*

		# For /etc/dump1090-fa/wisdom.local
		keepdir /etc/dump1090-fa/

		# Tooling to generate custom wisdom:
		exeinto /usr/libexec/dump1090
		doexe starch-benchmark
	fi
}

pkg_postinst() {
	tmpfiles_process dump1090.conf
}

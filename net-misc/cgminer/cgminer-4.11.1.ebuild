# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs udev

DESCRIPTION="Bitcoin CPU/GPU/FPGA/ASIC miner in C"
HOMEPAGE="https://bitcointalk.org/?topic=28402.msg357369 https://github.com/ckolivas/cgminer"
SRC_URI="http://ck.kolivas.org/apps/cgminer/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

HARDWARE="ants1 ants2 ants3 avalon avalon2 avalon4 avalon7 avalon-miner bab bflsc bitforce bitfury bitmine-A1 blockerupter cointerra drillbit hashfast hashratio icarus klondike knc minion modminer sp10 sp30"
IUSE="examples udev ncurses ${HARDWARE}"

REQUIRED_USE="|| ( ${HARDWARE} )"

RDEPEND="
	net-misc/curl
	>=dev-libs/jansson-2.6:=
	virtual/libusb:1[udev]
	ncurses? ( sys-libs/ncurses:0= )
	udev? ( virtual/libudev )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
DOCS=( AUTHORS NEWS {API-,}README)

src_configure() {
	append-cflags -fcommon
	if use icarus || use bitforce || use modminer; then
		DOCS+="FPGA-README"
	fi
	if use avalon || use bflsc; then
		DOCS+="ASIC-README"
	fi

	# PKG_CHECK_MODULES needs PKG_CONFIG for --with-system-jansson.
	export PKG_CONFIG="$(tc-getPKG_CONFIG)"
	local myeconfargs=(
		$(use_with ncurses curses)
		$(use_enable ants1)
		$(use_enable ants2)
		$(use_enable ants3)
		$(use_enable avalon)
		$(use_enable avalon2)
		$(use_enable avalon4)
		$(use_enable avalon7)
		$(use_enable avalon-miner)
		$(use_enable bab)
		$(use_enable bitmine-A1)
		$(use_enable bflsc)
		$(use_enable bitforce)
		$(use_enable bitfury)
		$(use_enable blockerupter)
		$(use_enable cointerra)
		$(use_enable drillbit)
		$(use_enable hashfast)
		$(use_enable hashratio)
		$(use_enable icarus)
		$(use_enable klondike)
		$(use_enable knc)
		$(use_enable minion)
		$(use_enable modminer)
		$(use_enable sp10)
		$(use_enable sp30)
		$(use_enable udev)
		--disable-forcecombo
		--with-system-libusb
		--with-system-jansson
	)
	econf "${myeconfargs[@]}" \
		  NCURSES_LIBS="$(${PKG_CONFIG} --libs ncurses)"

	# sanitize directories (is this still needed?)
	sed -i 's~^\(\#define CGMINER_PREFIX \).*$~\1"'"${EPREFIX}/usr/lib/cgminer"'"~' config.h || die
}

src_install() { # How about using some make install?
	dobin cgminer

	use udev && udev_dorules 01-cgminer.rules

	if use examples; then
		docinto examples
		dodoc api-example.{c,php} miner.php API.java example.conf
	fi
}

pkg_postinst() {
	use udev && udev_reload
}

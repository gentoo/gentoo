# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Bitcoin CPU/GPU/FPGA/ASIC miner in C"
HOMEPAGE="https://bitcointalk.org/?topic=28402.msg357369 https://github.com/ckolivas/cgminer"
SRC_URI="http://ck.kolivas.org/apps/cgminer/${P}.tar.bz2"
#SRC_URI="http://ck.kolivas.org/apps/cgminer/4.5/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

HARDWARE="ants1 ants2 ants3 avalon avalon2 avalon4 avalon7 avalon-miner bab bflsc bitforce bitfury bitmine_A1 blockerupter cointerra drillbit hashfast hashratio icarus klondike knc minion modminer sp10 sp30"
IUSE="doc examples udev hardened ncurses ${HARDWARE}"

REQUIRED_USE="|| ( ${HARDWARE} )"

RDEPEND="
	net-misc/curl
	>=dev-libs/jansson-2.6
	virtual/libusb:1[udev]
	ncurses? ( sys-libs/ncurses:0= )
	udev? ( virtual/libudev )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	use hardened && append-cflags "-no-pie"
	append-cflags -fcommon

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
		$(use_enable bitmine_A1)
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

	if use udev; then
		insinto /lib/udev/rules.d
		use udev && doins 01-cgminer.rules
	fi

	if use doc; then
		dodoc AUTHORS NEWS README API-README
		use icarus || use bitforce || use modminer && dodoc FPGA-README
		use avalon || use bflsc && dodoc ASIC-README
	fi

	if use examples; then
		docinto examples
		dodoc api-example.php miner.php API.java api-example.c example.conf
	fi
}

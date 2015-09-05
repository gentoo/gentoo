# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Modular Bitcoin ASIC/FPGA/GPU/CPU miner in C"
HOMEPAGE="https://bitcointalk.org/?topic=168174"
SRC_URI="http://luke.dashjr.org/programs/bitcoin/files/${PN}/${PV}/${P}.txz -> ${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

# TODO: knc (needs i2c-tools header)
# TODO: minergate (needs actual miner_gate)
# TODO: titan
IUSE="adl antminer avalon avalonmm bfx bifury bitforce bfsb bigpic bitfury cointerra cpumining drillbit dualminer examples gridseed hardened hashbuster hashbuster2 hashfast icarus jingtian klondike +libusb littlefury lm_sensors metabank modminer nanofury ncurses opencl proxy proxy_getwork proxy_stratum rockminer screen scrypt twinfury +udev udev-broad-rules unicode x6500 zeusminer ztex"
REQUIRED_USE='
	|| ( antminer avalon avalonmm bfsb bfx bifury bigpic bitforce bitfury cointerra cpumining drillbit dualminer gridseed hashbuster hashbuster2 hashfast icarus klondike littlefury metabank modminer nanofury opencl proxy twinfury x6500 zeusminer ztex )
	adl? ( opencl )
	bfsb? ( bitfury )
	bfx? ( bitfury libusb )
	bigpic? ( bitfury )
	drillbit? ( bitfury )
	dualminer? ( icarus )
	gridseed? ( scrypt )
	hashbuster? ( bitfury )
	hashbuster2? ( bitfury libusb )
	klondike? ( libusb )
	littlefury? ( bitfury )
	lm_sensors? ( opencl )
	metabank? ( bitfury )
	nanofury? ( bitfury )
	scrypt? ( || ( cpumining dualminer gridseed opencl proxy zeusminer ) )
	twinfury? ( bitfury )
	unicode? ( ncurses )
	proxy? ( || ( proxy_getwork proxy_stratum ) )
	proxy_getwork? ( proxy )
	proxy_stratum? ( proxy )
	x6500? ( libusb )
	zeusminer? ( scrypt )
	ztex? ( libusb )
'

DEPEND='
	net-misc/curl
	ncurses? (
		sys-libs/ncurses:=[unicode?]
	)
	>=dev-libs/jansson-2
	dev-libs/libbase58
	net-libs/libblkmaker
	udev? (
		virtual/udev
	)
	hashbuster? (
		dev-libs/hidapi
	)
	libusb? (
		virtual/libusb:1
	)
	lm_sensors? (
		sys-apps/lm_sensors
	)
	nanofury? (
		dev-libs/hidapi
	)
	proxy_getwork? (
		net-libs/libmicrohttpd
	)
	proxy_stratum? (
		dev-libs/libevent
	)
	screen? (
		app-misc/screen
		|| (
			>=sys-apps/coreutils-8.15
			sys-freebsd/freebsd-bin
			app-misc/realpath
		)
	)
'
RDEPEND="${DEPEND}
	opencl? (
		|| (
			virtual/opencl
			dev-util/nvidia-cuda-sdk[opencl]
		)
	)
"
DEPEND="${DEPEND}
	virtual/pkgconfig
	>=dev-libs/uthash-1.9.7
	sys-apps/sed
	cpumining? (
		amd64? (
			>=dev-lang/yasm-1.0.1
		)
		x86? (
			>=dev-lang/yasm-1.0.1
		)
	)
"

src_configure() {
	local CFLAGS="${CFLAGS}"
	local with_curses
	use hardened && CFLAGS="${CFLAGS} -nopie"

	if use ncurses; then
		if use unicode; then
			with_curses='--with-curses=ncursesw'
		else
			with_curses='--with-curses=ncurses'
		fi
	else
		with_curses='--without-curses'
	fi

	CFLAGS="${CFLAGS}" \
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable adl) \
		$(use_enable antminer) \
		$(use_enable avalon) \
		$(use_enable avalonmm) \
		$(use_enable bifury) \
		$(use_enable bitforce) \
		$(use_enable bfsb) \
		$(use_enable bfx) \
		$(use_enable bigpic) \
		$(use_enable bitfury) \
		$(use_enable cointerra) \
		$(use_enable cpumining) \
		$(use_enable drillbit) \
		$(use_enable dualminer) \
		$(use_enable gridseed) \
		$(use_enable hashbuster) \
		$(use_enable hashbuster2 hashbusterusb) \
		$(use_enable hashfast) \
		$(use_enable icarus) \
		$(use_enable jingtian) \
		$(use_enable klondike) \
		$(use_enable littlefury) \
		$(use_enable metabank) \
		$(use_enable modminer) \
		$(use_enable nanofury) \
		$(use_enable opencl) \
		$(use_enable rockminer) \
		$(use_enable scrypt) \
		$(use_enable twinfury) \
		--with-system-libblkmaker \
		$with_curses \
		$(use_with udev libudev) \
		$(use_enable udev-broad-rules broad-udevrules) \
		$(use_with lm_sensors sensors) \
		$(use_with proxy_getwork libmicrohttpd) \
		$(use_with proxy_stratum libevent) \
		$(use_enable x6500) \
		$(use_enable zeusminer) \
		$(use_enable ztex)
}

src_install() {
	emake install DESTDIR="$D"
	if ! use examples; then
		rm -r "${D}/usr/share/doc/${PF}/rpc-examples"
	fi
	if ! use screen; then
		rm "${D}/usr/bin/start-bfgminer.sh"
	fi
}

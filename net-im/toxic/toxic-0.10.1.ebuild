# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit python-single-r1 xdg

DESCRIPTION="A curses-based client for Tox"
HOMEPAGE="https://github.com/JFreegman/toxic"
SRC_URI="https://github.com/JFreegman/toxic/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio-notify debug doc llvm notification png python qrcode +sound +video +X"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	video? ( sound X ) "

RDEPEND="dev-libs/libconfig:=
	net-libs/tox:=
	net-misc/curl
	sys-libs/ncurses:=
	audio-notify? (
		media-libs/freealut
		media-libs/openal
	)
	notification? ( x11-libs/libnotify )
	debug? ( llvm? ( sys-devel/llvm:* ) )
	python? ( ${PYTHON_DEPS} )
	qrcode? (
		media-gfx/qrencode:=
		png? ( media-libs/libpng )
	)
	sound? (
		media-libs/openal
		net-libs/tox:=[av]
	)
	X? (
		x11-base/xorg-proto
		x11-libs/libX11
	)"

DEPEND="${RDEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	#prevent man files from being compressed.
	sed -i -e "/gzip/d" cfg/targets/install.mk || die "Unable to prevent compression of man pages."
	#Fix incorrect linkage of pthread (may be optional)
	sed -i -e 's/pthread/lpthread/g' Makefile || die "Unable to fix linking of pthread."
	#Makefile sets some required CFLAGS only if CFLAGS variable is undefined,
	#This line changes the "lazy set if absent" assignment to a "lazy set" assignment.
	#look below in src_configure to see how CFLAGS are passed to the makefile in USER_CFLAGS
	sed -i -e 's/?=/=/g' Makefile || die "Unable to force CFLAGS and LDFLAGS"
}

src_configure() {
	if ! use audio-notify; then
		USER_CFLAGS+="-DDISABLE_SOUND_NOTIFY=1 "
	fi
	if use debug; then
		USER_CFLAGS+="-DENABLE_RELEASE=0 "
		if use llvm; then
			USER_CFLAGS+="-DENABLE_ASAN=1 "
		fi
	fi
	if ! use notification; then
		USER_CFLAGS+="-DDISABLE_DESKTOP_NOTIFY=1 "
	fi
	if ! use png; then
		USER_CFLAGS+="-DDISABLE_QRPNG=1 "
	fi
	if use python; then
		USER_CFLAGS+="-DENABLE_PYTHON=1"
	fi
	if ! use qrcode; then
		USER_CFLAGS+="-DDISABLE_QRCODE=1"
	fi
	if ! use sound; then
		USER_CFLAGS+="-DDISABLE_AV=1 "
	fi
	if ! use video; then
		USER_CFLAGS+="-DDISABLE_VI=1"
	fi
	if ! use X; then
		USER_CFLAGS+="-DDISABLE_X11=1 "
	fi
	USER_CFLAGS+="${CFLAGS}"
	export USER_CFLAGS
	export USER_LDFLAGS="${LDFLAGS}"
	#set install directory to /usr.
	sed -i -e "s,/usr/local,${EPREFIX}/usr,g" cfg/global_vars.mk || die "Failed to set install directory!"
}

src_install() {
	default
	if ! use audio-notify; then
		rm -r "${ED}"/usr/share/${PN}/sounds || die "Could not remove sounds directory"
	fi
}

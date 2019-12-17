# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LGPL-ed pc emulator"
HOMEPAGE="http://bochs.sourceforge.net/"
SRC_URI="mirror://sourceforge/bochs/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

IUSE="3dnow avx debugger doc gdb ncurses readline svga sdl +smp vnc X +x86-64"
REQUIRED_USE="
	avx? ( x86-64 )
	gdb? ( !debugger !smp )
	debugger? ( !gdb )
"

RDEPEND="
	X? ( x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXpm )
	sdl? ( media-libs/libsdl )
	svga? ( media-libs/svgalib )
	readline? ( sys-libs/readline:= )
	ncurses? ( sys-libs/ncurses:= )
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	doc? ( app-text/docbook-sgml-utils )
	sys-apps/sed
	>=app-text/opensp-1.5
"

src_prepare() {
	default
	sed -i "s:^docdir.*:docdir = ${EPREFIX}/usr/share/doc/${PF}:" \
		Makefile.in || die
}

src_configure() {
	econf \
		--enable-all-optimizations \
		--enable-idle-hack \
		--enable-cdrom \
		--enable-clgd54xx \
		--enable-cpu-level=6 \
		--enable-disasm \
		--enable-e1000 \
		--enable-gameport \
		--enable-iodebug \
		--enable-monitor-mwait \
		--enable-ne2000 \
		--enable-plugins \
		--enable-pci \
		--enable-pnic \
		--enable-raw-serial \
		--enable-sb16=linux \
		--enable-usb \
		--enable-usb-ohci \
		--enable-usb-xhci \
		--prefix=/usr \
		--with-nogui \
		--without-wx \
		$(use_enable 3dnow) \
		$(use_enable avx) \
		$(use_enable debugger) \
		$(use_enable doc docbook) \
		$(use_enable gdb gdb-stub) \
		$(use_enable readline) \
		$(use_enable smp) \
		$(use_enable x86-64) \
		$(use_with ncurses term) \
		$(use_with sdl) \
		$(use_with svga) \
		$(use_with vnc rfb) \
		$(use_with X x) \
		$(use_with X x11) \
		${myconf}
}

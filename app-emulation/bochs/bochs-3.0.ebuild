# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LGPL-ed pc emulator"
HOMEPAGE="http://bochs.sourceforge.io/"
MY_P="REL_$(ver_cut 1)_$(ver_cut 2)_FINAL"
SRC_URI="https://github.com/bochs-emu/Bochs/archive/refs/tags/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Bochs-${MY_P}/bochs"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

IUSE="3dnow avx debugger doc gdb ncurses readline sdl +smp vnc X +x86-64"
REQUIRED_USE="
	avx? ( x86-64 )
	gdb? ( !debugger !smp )
	debugger? ( !gdb )
"

RDEPEND="
	ncurses? ( sys-libs/ncurses:= )
	readline? ( sys-libs/readline:= )
	sdl? ( media-libs/libsdl )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXpm
	)
"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )
"
BDEPEND="
	>=app-text/opensp-1.5
	doc? ( app-text/docbook-sgml-utils )
"

src_prepare() {
	default

	sed -i "s:^docdir.*:docdir = ${EPREFIX}/usr/share/doc/${PF}:" \
		Makefile.in || die
	sed -i 's:| $(GZIP_BIN) -c >  $(DESTDIR)$(man1dir)/$$i.1.gz:> $(DESTDIR)$(man1dir)/$$i.1:' Makefile.in || die
	sed -i 's:$$i.1.gz:$$i.1:' Makefile.in || die
	sed -i 's:| $(GZIP_BIN) -c >  $(DESTDIR)$(man5dir)/$$i.5.gz:> $(DESTDIR)$(man5dir)/$$i.5:' Makefile.in || die
	sed -i 's:$$i.5.gz:$$i.5:' Makefile.in || die
}

src_configure() {
	econf \
		--enable-all-optimizations \
		--enable-idle-hack \
		--enable-cdrom \
		--enable-clgd54xx \
		--enable-cpu-level=6 \
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
		$(use_enable avx evex) \
		$(use_enable debugger) \
		$(use_enable doc docbook) \
		$(use_enable gdb gdb-stub) \
		$(use_enable readline) \
		$(use_enable smp) \
		$(use_enable x86-64) \
		$(use_with ncurses term) \
		$(use_with sdl) \
		$(use_with vnc rfb) \
		$(use_with X x) \
		$(use_with X x11)
}

src_install() {
	default

	# remove unneeded .la files the plugins load fine even without them.
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/bochs/bochs-2.4.1.ebuild,v 1.5 2010/09/04 09:22:32 lu_zero Exp $

inherit eutils wxwidgets

DESCRIPTION="a LGPL-ed pc emulator"
HOMEPAGE="http://bochs.sourceforge.net/"
SRC_URI="mirror://sourceforge/bochs/${P}.tar.gz
		http://bochs.sourceforge.net/guestos/dlxlinux4.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="X debugger readline usb wxwidgets svga sdl ncurses vnc acpi"

RDEPEND="X? ( x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXpm )
	sdl? ( media-libs/libsdl )
	svga? ( media-libs/svgalib )
	wxwidgets? ( =x11-libs/wxGTK-2.8* )
	readline? ( sys-libs/readline )
	ncurses? ( sys-libs/ncurses )"

DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )
	>=sys-apps/sed-4
	>=app-text/opensp-1.5"

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}"

	# we already downloaded dlxlinux4.tar.gz so let the Makefile cp it instead
	# of downloading it again
	sed -i \
		-e "s:\$(WGET) \$(DLXLINUX_TAR_URL):cp ${DISTDIR}/dlxlinux4.tar.gz .:" \
		Makefile.in || \
		die "sed Makefile.in failed"
}

src_compile() {
	WX_GTK_VER=2.8

	use wxwidgets && \
		need-wxwidgets unicode

	use x86 && \
		myconf="--enable-idle-hack --enable-fast-function-calls"

	use amd64 && \
		myconf="--enable-x86-64"

	use wxwidgets && \
		myconf="${myconf} --with-wx"
	use wxwidgets || \
		myconf="${myconf} --without-wx"

	use vnc && \
		myconf="${myconf} --with-rfb"

	use X && \
		myconf="${myconf} --with-x11"

	use ncurses && \
		myconf="${myconf} --with-term"

	# --enable-all-optimizations causes bus error on sparc :(
	use sparc || \
		myconf="${myconf} --enable-all-optimizations"

	econf \
		--enable-pae \
		--enable-large-pages \
		--enable-global-pages \
		--enable-mtrr \
		--enable-repeat-speedups \
		--enable-trace-cache \
		--enable-fast-function-calls \
		--enable-ignore-bad-msr \
		--enable-disasm \
		--enable-logging \
		--enable-raw-serial \
		--enable-vbe \
		--enable-clgd54xx \
		--enable-fpu \
		--enable-vme \
		--enable-alignment-check \
		--enable-sep \
		--enable-popcnt \
		--enable-monitor-mwait \
		--enable-gameport \
		--enable-iodebug \
		--prefix=/usr \
		--enable-ne2000 \
		--enable-sb16=linux \
		--enable-plugins \
		--enable-cdrom \
		--enable-pci \
		--enable-pcidev \
		--enable-pnic \
		--enable-mmx \
		--enable-sse=2 \
		--enable-3dnow \
		--enable-cpu-level=6 \
		--enable-smp \
		--with-nogui \
		--enable-xsave \
		--enable-aes \
		$(use_enable usb) \
		$(use_enable readline) \
		$(use_enable debugger) \
		$(use_with X) \
		$(use_with sdl) \
		$(use_with svga) \
		$(use_enable acpi) \
		${myconf} || \
		die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install unpack_dlx || die "make install failed"

	# workaround
	make prefix="${D}/usr" install_dlx

	dodoc \
		CHANGES \
		PARAM_TREE.txt \
		README \
		README-plugins \
		TESTFORM.txt \
		TODO || \
		die "doco failed"

	if [ use vnc ]
	then
		dodoc README.rfb || die "dodoc failed"
	fi

	if [ use wxwidgets ]
	then
		dodoc README-wxWindows || die "dodoc failed"
	fi
}

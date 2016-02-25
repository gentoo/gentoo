# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome.org multilib-minimal xdg-utils

DESCRIPTION="A library for sending desktop notifications"
HOMEPAGE="https://git.gnome.org/browse/libnotify"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="+introspection test"

COMMON_DEPEND="app-eselect/eselect-notify-send
	>=dev-libs/glib-2.26:2[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-1.32 )"
RDEPEND="${COMMON_DEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-gtklibs-20140508-r4
		!app-emulation/emul-linux-x86-gtklibs[-abi_x86_32(-)]
	)"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/gobject-introspection-common-1.32
	>=dev-util/gtk-doc-am-1.14
	virtual/pkgconfig
	test? ( x11-libs/gtk+:3[${MULTILIB_USEDEP}] )"
PDEPEND="virtual/notification-daemon"

DOCS=( AUTHORS ChangeLog NEWS )

src_prepare() {
	sed -i -e 's:noinst_PROG:check_PROG:' tests/Makefile.am || die

	if ! use test; then
		sed -i -e '/PKG_CHECK_MODULES(TESTS/d' configure.ac || die
	fi

	eautoreconf
}

multilib_src_configure() {
	xdg_environment_reset
	ECONF_SOURCE=${S} econf \
		--disable-static \
		$(multilib_native_use_enable introspection)

	# work-around gtk-doc out-of-source brokedness
	if multilib_is_native_abi; then
		ln -s "${S}"/docs/reference/html docs/reference/html || die
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files

	mv "${ED}"/usr/bin/{,libnotify-}notify-send #379941
}

pkg_postinst() {
	eselect notify-send update ifunset
}

pkg_postrm() {
	eselect notify-send update ifunset
}

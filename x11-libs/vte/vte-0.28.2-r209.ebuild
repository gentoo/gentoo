# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="GNOME terminal widget"
HOMEPAGE="https://wiki.gnome.org/Apps/Terminal/VTE"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE="debug +introspection"

RDEPEND="
	>=dev-libs/glib-2.26:2
	>=x11-libs/gtk+-2.20:2[introspection?]
	>=x11-libs/pango-1.22.0

	sys-libs/ncurses:0=
	x11-libs/libX11
	x11-libs/libXft

	introspection? ( >=dev-libs/gobject-introspection-0.9.0:= )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	sys-devel/gettext
"
PDEPEND="x11-libs/gnome-pty-helper"

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=663779
	"${FILESDIR}"/${PN}-0.30.1-alt-meta.patch

	# https://bugzilla.gnome.org/show_bug.cgi?id=652290
	"${FILESDIR}"/${PN}-0.28.2-interix.patch

	# Fix CVE-2012-2738, upstream bug #676090
	"${FILESDIR}"/${PN}-0.28.2-limit-arguments.patch

	# Fix https://bugzilla.gnome.org/show_bug.cgi?id=542087
	# Patch from https://github.com/pld-linux/vte0/commit/1e8dce16b239e5d378b02e4d04a60e823df36257
	"${FILESDIR}"/${PN}-0.28.2-repaint-after-change-scroll-region.patch
)

DOCS="AUTHORS ChangeLog HACKING NEWS README"

src_configure() {
	local myconf=""

	if [[ ${CHOST} == *-interix* ]]; then
		myconf="${myconf} --disable-Bsymbolic"

		# interix stropts.h is empty...
		export ac_cv_header_stropts_h=no
	fi

	# Do not disable gnome-pty-helper, bug #401389
	gnome2_src_configure --disable-python \
		--disable-deprecation \
		--disable-glade-catalogue \
		--disable-static \
		$(use_enable debug) \
		$(use_enable introspection) \
		--with-gtk=2.0 \
		${myconf}
}

src_install() {
	gnome2_src_install

	rm -v "${ED}usr/libexec/gnome-pty-helper" || die
}

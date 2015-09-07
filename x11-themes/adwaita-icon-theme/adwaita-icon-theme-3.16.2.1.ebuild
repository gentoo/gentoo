# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2 versionator

DESCRIPTION="GNOME default icon theme"
HOMEPAGE="https://www.gnome.org/ http://people.freedesktop.org/~jimmac/icons/#git"

SRC_URI="${SRC_URI}
	branding? ( http://www.mail-archive.com/tango-artists@lists.freedesktop.org/msg00043/tango-gentoo-v1.1.tar.gz )"

LICENSE="|| ( LGPL-3 CC-BY-SA-3.0 )
	branding? ( CC-Sampling-Plus-1.0 )"
SLOT="0"
IUSE="branding"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

COMMON_DEPEND="
	>=x11-themes/hicolor-icon-theme-0.10
"
RDEPEND="${COMMON_DEPEND}
	gnome-base/librsvg:2
	!<x11-themes/gnome-themes-standard-3.14
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"
# This ebuild does not install any binaries
RESTRICT="binchecks strip"

src_prepare() {
	if use branding; then
		for i in 16 22 24 32 48; do
			cp "${WORKDIR}"/tango-gentoo-v1.1/${i}x${i}/gentoo.png \
			"${S}"/Adwaita/${i}x${i}/places/start-here.png \
			|| die "Copying gentoo logos failed"
		done
	fi

	# Install cursors in the right place
	sed -e 's:^\(cursordir.*\)icons\(.*\):\1cursors/xorg-x11\2:' \
		-i "${S}"/Makefile.am \
		-i "${S}"/Makefile.in || die

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure GTK_UPDATE_ICON_CACHE=$(type -P true)
}

src_install() {
	gnome2_src_install
	# Buggy directory due to drop of intltool usage
	rm -rf "${D}"/usr/locale
}

pkg_postinst() {
	gnome2_pkg_postinst
	elog "$PF no longer installs the"
	elog "/usr/share/cursors/xorg-x11/default symlink. Instead, desktop"
	elog "environments are expected to set the cursor theme using the"
	elog "XCURSOR_THEME environment variable or other means."
	elog "If you are seeing old-style X11 cursors in GNOME or Cinnamon,"
	elog "make sure you have >=gnome-base/gnome-session-3.14.0-r2"
	elog "and then log out and log in again."
}

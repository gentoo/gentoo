# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome2 fixheadtails

DESCRIPTION="A gtk+ frontend for libgksu"
HOMEPAGE="http://www.nongnu.org/gksu/"
SRC_URI="https://people.debian.org/~kov/gksu/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="gnome"

RDEPEND="
	>=x11-libs/libgksu-2.0.8
	>=x11-libs/gtk+-2.4:2
	>=gnome-base/gconf-2
	gnome? (
		>=gnome-base/nautilus-2
		x11-terms/gnome-terminal )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	ht_fix_file "${S}/gksu-migrate-conf.sh"

	# https://savannah.nongnu.org/bugs/index.php?36127
	eapply "${FILESDIR}"/${PN}-2.0.2-glib-2.31.patch

	if use gnome ; then
		sed 's/x-terminal-emulator/gnome-terminal/' \
			-i gksu.desktop || die "sed 1 failed"

		# Conditional patch to avoid eautoreconf
		# https://savannah.nongnu.org/bugs/index.php?36129
		eapply "${FILESDIR}"/${PN}-2.0.2-nautilus-dir.patch

		sed -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
			-i configure.ac || die #467024

		eautoreconf
	else
		sed 's/dist_desktop_DATA = $(desktop_in_files:.desktop.in=.desktop)/dist_desktop_DATA =/' \
			-i Makefile.am Makefile.in || die "sed 2 failed"
	fi

	# Fix build with format-security, bug #517664
	eapply "${FILESDIR}"/${PN}-2.0.2-format_security.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable gnome nautilus-extension)
}

src_install() {
	gnome2_src_install
	chmod +x "${D}/usr/share/gksu/gksu-migrate-conf.sh"
}

pkg_postinst() {
	gnome2_pkg_postinst
	einfo 'updating configuration'
	"${ROOT}"/usr/share/gksu/gksu-migrate-conf.sh
	einfo ""
	einfo "A note on gksudo:  It actually runs sudo to get it's work done"
	einfo "However, by default, Gentoo's sudo wipes your environment."
	einfo "This means that gksudo will fail to run any X-based programs."
	einfo "You need to either add yourself to wheel and uncomment this line"
	einfo "in your /etc/sudoers:"
	einfo "Defaults:%wheel   !env_reset"
	einfo "Or remove the env_reset line entirely.  This can cause security"
	einfo "problems; if you don't trust your users, don't do this, use gksu"
	einfo "instead."
}

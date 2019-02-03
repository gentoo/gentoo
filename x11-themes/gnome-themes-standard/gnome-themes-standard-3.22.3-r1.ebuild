# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools gnome.org gnome2-utils

DESCRIPTION="Standard Themes for GNOME Applications"
HOMEPAGE="https://git.gnome.org/browse/gnome-themes-standard/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-solaris ~x86-solaris"

# Depend on gsettings-desktop-schemas-3.4 to make sure 3.2 users don't lose
# their default background image
RDEPEND="
	>=gnome-base/gsettings-desktop-schemas-3.4
"
DEPEND="
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	# https://bugzilla.gnome.org/show_bug.cgi?id=746920
	"${FILESDIR}"/${PN}-3.14.2.3-srcdir.patch
	# Leave build of gtk+:2 engine to x11-themes/gtk-engines-adwaita
	"${FILESDIR}"/${PN}-3.22.2-exclude-engine.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-static \
		--disable-gtk2-engine \
		--disable-gtk3-engine \
		GTK_UPDATE_ICON_CACHE=$(type -P true)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

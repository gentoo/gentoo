# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools gnome.org

DESCRIPTION="Standard Themes for GNOME Applications"
HOMEPAGE="https://git.gnome.org/browse/gnome-themes-standard/"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~arm-linux ~x86-linux ~x64-solaris ~x86-solaris"

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
	"${FILESDIR}"/${PN}-3.20.2-exclude-engine.patch
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

src_install() {
	emake install DESTDIR="${D}"
}

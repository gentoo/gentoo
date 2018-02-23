# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit multilib xfconf

DESCRIPTION="A time managing application (and panel plug-in) for the Xfce desktop environment"
HOMEPAGE="https://git.xfce.org/apps/orage/"
SRC_URI="mirror://xfce/src/apps/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="berkdb dbus debug libnotify +xfce_plugins_clock"

RDEPEND=">=dev-libs/libical-0.48:=
	dev-libs/popt:=
	>=x11-libs/gtk+-2.10:2=
	berkdb? ( >=sys-libs/db-4:= )
	dbus? ( >=dev-libs/dbus-glib-0.100:= )
	libnotify? ( >=x11-libs/libnotify-0.7:= )
	xfce_plugins_clock? ( >=xfce-base/xfce4-panel-4.10:= )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	>=sys-devel/libtool-2.2.6
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		--libexecdir="${EPREFIX}/usr/$(get_libdir)"
		--docdir="${EPREFIX}"/usr/share/doc/${PF}/html
		$(use_enable xfce_plugins_clock libxfce4panel)
		$(use_enable dbus)
		$(use_enable libnotify)
		$(use_with berkdb bdb4)
		$(xfconf_use_debug)
		)

	DOCS=( AUTHORS ChangeLog NEWS README TODO )

	# PM doesn't let directory to be replaced by a symlink, see src_install()
	rm -rf "${EROOT}"/usr/share/${PN}/doc
}

src_install() {
	xfconf_src_install \
		docdir="${EPREFIX}"/usr/share/doc/${PF}/html \
		imagesdir="${EPREFIX}"/usr/share/doc/${PF}/html/images

	# Create compability symlink for retarded path hardcoding in src/{mainbox,parameters}.c
	dosym /usr/share/doc/${PF}/html /usr/share/${PN}/doc/C
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mate-base/mate-menus/mate-menus-1.8.0.ebuild,v 1.6 2015/04/08 18:13:42 mgorny Exp $

EAPI="5"

GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit gnome2 python-r1

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE menu system, implementing the F.D.O cross-desktop spec"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="debug +introspection python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.15.2:2
	virtual/libintl:0
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:0 )
	python? (
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40:*
	>=mate-base/mate-common-1.6:0
	sys-devel/gettext:*
	virtual/pkgconfig:*"

my_command() {
	if use python ; then
		python_foreach_impl run_in_build_dir $@
	else
		$@
	fi
}

src_configure() {
	G2CONF="${G2CONF} \
		$(use_enable python) \
		$(use_enable introspection)"

	# Do NOT compile with --disable-debug/--enable-debug=no as it disables API
	# usage checks.
	if ! use debug ; then
		G2CONF="${G2CONF} --enable-debug=minimum"
	fi

	if use python ; then
		python_copy_sources
	fi

	my_command gnome2_src_configure
}

src_compile() {
	my_command gnome2_src_compile
}

src_test() {
	my_command emake check
}

DOCS="AUTHORS ChangeLog NEWS README"

src_install() {
	my_command gnome2_src_install

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-mate"
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit python-r1 mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE menu system, implementing the F.D.O cross-desktop spec"
LICENSE="GPL-2 LGPL-2"
SLOT="0"

IUSE="debug +introspection python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.36.0:2
	virtual/libintl:0
	introspection? ( >=dev-libs/gobject-introspection-0.6.7:= )
	python? (
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_prepare() {
	mate_src_prepare
	use python && python_copy_sources
}

src_configure() {
	# Do NOT compile with --disable-debug/--enable-debug=no as it disables API
	# usage checks.
	mate_py_cond_func_wrap mate_src_configure \
		--enable-debug=$(usex debug yes minimum) \
		$(use_enable python) \
		$(use_enable introspection)
}

src_compile() {
	mate_py_cond_func_wrap default
}

src_test() {
	mate_py_cond_func_wrap emake check
}

src_install() {
	mate_py_cond_func_wrap mate_src_install

	exeinto /etc/X11/xinit/xinitrc.d/
	doexe "${FILESDIR}/10-xdg-menu-mate"
}

pkg_postinst() {
	mate_pkg_postinst
	einfo "Due to upstream bug"
	einfo "https://github.com/mate-desktop/mate-menus/issues/2,"
	einfo "it is highly recommended to run the following command"
	einfo "once you have logged in to your desktop for the first time:"
	einfo "cd ~/.config/menus && ln -s {,mate-}applications-merged"
}

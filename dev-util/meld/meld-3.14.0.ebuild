# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/meld/meld-3.14.0.ebuild,v 1.1 2015/07/27 14:00:06 tetromino Exp $

EAPI="5"
GCONF_DEBUG="no"
PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit gnome2 distutils-r1

DESCRIPTION="A graphical diff and merge tool"
HOMEPAGE="http://meldmerge.org/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.36:2[dbus]
	dev-python/dbus-python[${PYTHON_USEDEP}]
	>=dev-python/pygobject-3.8:3[cairo,${PYTHON_USEDEP}]
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.12:3[introspection]
	>=x11-libs/gtksourceview-3.10:3.0[introspection]
	x11-themes/hicolor-icon-theme
"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/itstool
	sys-devel/gettext
"

python_compile_all() {
	mydistutilsargs=( --no-update-icon-cache --no-compile-schemas )
}

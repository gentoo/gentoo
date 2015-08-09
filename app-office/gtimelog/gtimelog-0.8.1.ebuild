# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=true
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1 virtualx

DESCRIPTION="A small Gtk+ application for keeping track of your time"
HOMEPAGE="http://mg.pov.lt/gtimelog/"
LICENSE="GPL-2"
SLOT="0"

SRC_URI="https://launchpad.net/gtimelog/devel/${PV}/+download/${P}.tar.gz"

KEYWORDS="amd64 x86"

IUSE="ayatana test"

# gnome-base/gnome-desktop provides gnome-week.png
RDEPEND="
	dev-libs/gobject-introspection
	dev-python/dbus-python
	dev-python/pygobject:3
	gnome-base/gnome-desktop:2
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]
	ayatana? ( dev-libs/libappindicator:3[introspection] )
"
DEPEND="test? (
	${RDEPEND}
	ayatana? ( dev-libs/libappindicator:3[introspection] ) )
"

DOCS="HACKING.txt NEWS.txt NOTES.txt README.txt"

src_prepare() {
	# Support prefixed installation
	sed -e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-i src/gtimelog/main.py || die "sed failed"

	sed -i -e 's/python2.3/python/' scripts/export-my-calendar.py || die

	sed -i -e 's/Application;//' gtimelog.desktop || die #462958

	distutils-r1_src_prepare
}

src_test() {
	VIRTUALX_COMMAND=distutils-r1_src_test virtualmake
}

src_install() {
	domenu gtimelog.desktop
	doicon src/gtimelog/gtimelog-*.png
	insinto /usr/share/gtimelog
	doins src/gtimelog/*.ui src/gtimelog/gtimelog.png
	exeinto /usr/share/gtimelog/scripts
	doexe scripts/*.py

	distutils-r1_src_install
	python_fix_shebang "${ED}"

	# Don't install icons in /usr/lib/python*
	find "${ED}/$(python_get_sitedir)" -regex '.*\(png\|ui\)$' -exec rm -f {} + || die
}

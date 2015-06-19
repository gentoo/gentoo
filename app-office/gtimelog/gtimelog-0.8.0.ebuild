# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gtimelog/gtimelog-0.8.0.ebuild,v 1.3 2013/03/25 16:15:33 ago Exp $

EAPI="4"
PYTHON_DEPEND="2"

inherit eutils distutils virtualx

DESCRIPTION="A small Gtk+ application for keeping track of your time"
HOMEPAGE="http://mg.pov.lt/gtimelog/"
LICENSE="GPL-2"
SLOT="0"

SRC_URI="https://launchpad.net/gtimelog/devel/${PV}/+download/${P}.tar.gz"

KEYWORDS="amd64 x86"

IUSE="ayatana test"

# gnome-base/gnome-desktop provides gnome-week.png
RDEPEND="dev-libs/gobject-introspection
	dev-python/dbus-python
	dev-python/pygobject:3
	gnome-base/gnome-desktop:2
	x11-libs/gtk+:3[introspection]
	x11-libs/pango[introspection]

	ayatana? ( dev-libs/libappindicator:3[introspection] )"
DEPEND="test? (
	${RDEPEND}
	ayatana? ( dev-libs/libappindicator:3[introspection] ) )"

DISTUTILS_SRC_TEST="setup.py"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup

	DOCS="HACKING.txt NEWS.txt NOTES.txt README.txt"
}

src_prepare() {
	python_convert_shebangs -r 2 .
	# Support prefixed installation
	sed -e "s:\"/usr:\"${EPREFIX}/usr:g" \
		-i src/gtimelog/main.py || die "sed failed"
	distutils_src_prepare
}

src_test() {
	VIRTUALX_COMMAND=distutils_src_test virtualmake
}

src_install() {
	domenu gtimelog.desktop
	doicon src/gtimelog/gtimelog-*.png
	insinto /usr/share/gtimelog
	doins src/gtimelog/*.ui src/gtimelog/gtimelog.png
	exeinto /usr/share/gtimelog/scripts
	doexe scripts/*.py

	distutils_src_install

	# Don't install icons in /usr/lib/python*
	find "${ED}/$(python_get_sitedir)" -regex '.*\(png\|ui\)$' -exec rm -f {} + || die
}

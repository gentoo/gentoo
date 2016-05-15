# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
PYTHON_COMPAT=( python2_7 )
inherit kde4-base distutils-r1

DESCRIPTION="Touchpad configuration and management tool for KDE"
HOMEPAGE="http://synaptiks.readthedocs.org"
SRC_URI="mirror://pypi/s/${PN}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug doc +upower"

RDEPEND="
	>=dev-python/PyQt4-4.7[${PYTHON_USEDEP}]
	>=dev-python/pyudev-0.8[pyqt4,${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	$(add_kdebase_dep pykde4 "${PYTHON_USEDEP}" )
	$(add_kdeapps_dep kde-dev-scripts)
	>=x11-drivers/xf86-input-synaptics-1.3
	>=x11-libs/libXi-1.4
	x11-libs/libXtst
	upower? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		|| ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils )
	)
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	sys-devel/gettext
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${P}-templatesfix.patch"
	"${FILESDIR}/${PN}-0.8.1-removedfeatures.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	sed -i -e "s/, 'sphinxcontrib.issuetracker'//" doc/conf.py || die
}

python_compile_all() {
	if use doc; then
		einfo "Generating documentation"
		pushd doc > /dev/null
		sphinx-build . _build || die
		popd > /dev/null
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/. )
	distutils-r1_python_install_all
}

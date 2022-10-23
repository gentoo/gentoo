# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit desktop distutils-r1 qmake-utils virtualx xdg

DESCRIPTION="Qt scientific plotting package with good Postscript output"
HOMEPAGE="https://veusz.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus hdf5"

COMMON_DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/PyQt5[widgets,svg,printsupport,${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	dev-python/sip:5[${PYTHON_USEDEP}]
"

distutils_enable_sphinx Documents/manual-source \
	dev-python/alabaster

src_prepare() {
	distutils-r1_src_prepare
	xdg_environment_reset
}

python_compile() {
	distutils-r1_python_compile build_ext --qmake-exe=$(qt5_get_bindir)/qmake
}

python_test() {
	VIRTUALX_COMMAND="${EPYTHON}" \
		VEUSZ_RESOURCE_DIR="${S}" \
		virtx tests/runselftest.py
}

python_install() {
	distutils-r1_python_install
	# symlink the license, bug #341653
	rm "${D}/$(python_get_sitedir)"/${PN}/{COPYING,AUTHORS,ChangeLog} || die
	mkdir -p "${D}/$(python_get_sitedir)" || die
	cat >> "${D}/$(python_get_sitedir)"/${PN}/COPYING <<- EOF
	Please visit

	https://www.gnu.org/licenses/gpl-2.0.html

	for the full license text.
	EOF
}

python_install_all() {
	distutils-r1_python_install_all

	doicon icons/veusz.png
	domenu "${FILESDIR}"/veusz.desktop
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/veusz.xml
}

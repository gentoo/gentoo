# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit desktop distutils-r1 qmake-utils virtualx xdg

DESCRIPTION="Qt scientific plotting package with good Postscript output"
HOMEPAGE="https://veusz.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus doc hdf5"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/PyQt5[widgets,svg,printsupport,${PYTHON_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	<dev-python/sip-5[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"

src_prepare() {
	distutils-r1_src_prepare
	xdg_environment_reset
}

python_compile() {
	distutils-r1_python_compile build_ext --qmake-exe=$(qt5_get_bindir)/qmake
}

python_test() {
	distutils_install_for_testing
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

	if use doc; then
		dodoc Documents/manual/pdf/${PN}.pdf
		docinto html
		dodoc -r Documents/manual/html
	fi

	doicon icons/veusz.png
	domenu "${FILESDIR}"/veusz.desktop
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/veusz.xml
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit desktop distutils-r1 virtualx xdg

DESCRIPTION="Qt scientific plotting package with good Postscript output"
HOMEPAGE="https://veusz.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus doc fits hdf5 minuit"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/PyQt5[widgets,svg,printsupport,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	fits? ( dev-python/astropy[${PYTHON_USEDEP}] )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	minuit? ( || ( dev-python/iminuit[${PYTHON_USEDEP}] dev-python/pyminuit[${PYTHON_USEDEP}] ) )"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

src_prepare() {
	distutils-r1_src_prepare
	xdg_environment_reset
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

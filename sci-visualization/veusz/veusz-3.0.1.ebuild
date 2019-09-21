# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit eutils distutils-r1 virtualx xdg-utils gnome2-utils

DESCRIPTION="Qt scientific plotting package with good Postscript output"
HOMEPAGE="https://veusz.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/${P}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus doc emf fits hdf5 minuit"

CDEPEND="dev-python/PyQt5[widgets,svg,printsupport,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${CDEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	emf? ( dev-python/pyemf[$(python_gen_usedep 'python2*')] )
	fits? ( dev-python/astropy[${PYTHON_USEDEP}] )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	minuit? ( || ( dev-python/iminuit[${PYTHON_USEDEP}] dev-python/pyminuit[${PYTHON_USEDEP}] ) )"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

PATCHES=("${FILESDIR}/fix_spline.patch")

python_test() {
	distutils_install_for_testing
	cd tests || die
	VIRTUALX_COMMAND="${EPYTHON}" \
		VEUSZ_RESOURCE_DIR="${S}" \
		virtualmake runselftest.py
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

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

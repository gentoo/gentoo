# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit eutils fdo-mime distutils-r1 virtualx

DESCRIPTION="Qt scientific plotting package with good Postscript output"
HOMEPAGE="http://home.gna.org/veusz/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="dbus doc emf fits hdf5 minuit vo"

CDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/PyQt4-4.11.4[X,svg,${PYTHON_USEDEP}]
"
RDEPEND="${CDEPEND}
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	emf? ( dev-python/pyemf[$(python_gen_usedep 'python2*')] )
	fits? ( dev-python/astropy[${PYTHON_USEDEP}] )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	minuit? ( dev-python/pyminuit[${PYTHON_USEDEP}] )
	vo? (
		dev-python/astropy[${PYTHON_USEDEP}]
		dev-python/sampy[$(python_gen_usedep 'python2*')]
	)"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sip[${PYTHON_USEDEP}]
	"

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
	use doc && dodoc Documents/manual.pdf && \
		dohtml -r Documents/{manimages,manual.html}

	doicon icons/veusz.png
	domenu "${FILESDIR}"/veusz.desktop
	insinto /usr/share/mime/packages
	doins "${FILESDIR}"/veusz.xml
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}

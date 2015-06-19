# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/veusz/veusz-1.20.ebuild,v 1.3 2015/04/08 18:23:57 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit eutils fdo-mime distutils-r1 virtualx

DESCRIPTION="Qt scientific plotting package with good Postscript output"
HOMEPAGE="http://home.gna.org/veusz/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

IUSE="dbus doc emf fits hdf5 vo"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/PyQt4-4.6[X,svg,${PYTHON_USEDEP}]
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
	emf? ( dev-python/pyemf[$(python_gen_usedep 'python2*')] )
	fits? ( dev-python/astropy[${PYTHON_USEDEP}] )
	hdf5? ( dev-python/h5py[${PYTHON_USEDEP}] )
	vo? (
			dev-python/astropy[${PYTHON_USEDEP}]
			dev-python/sampy[$(python_gen_usedep 'python2*')]
		)"

python_test() {
	distutils_install_for_testing
	cd tests || die
	VIRTUALX_COMMAND="${EPYTHON}" \
		VEUSZ_RESOURCE_DIR="${TEST_DIR}/lib/veusz" \
		virtualmake runselftest.py
}

python_install() {
	distutils-r1_python_install
	# symlink the license, bug #341653
	ln -s "${PORTDIR}"/licenses/${LICENSE} \
		"${D}/$(python_get_sitedir)"/${PN}/COPYING || die
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

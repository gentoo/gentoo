# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/veusz/veusz-1.22.ebuild,v 1.4 2015/05/13 12:18:53 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

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
	>=dev-python/PyQt4-4.6[X,svg,${PYTHON_USEDEP}]
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

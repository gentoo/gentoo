# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/xia2/xia2-0.3.3.1.ebuild,v 1.6 2012/04/14 09:54:22 nativemad Exp $

EAPI=3

PYTHON_DEPEND="2"

inherit eutils python

DESCRIPTION="An automated data reduction system for crystallography"
HOMEPAGE="http://www.ccp4.ac.uk/xia/"
SRC_URI="http://www.ccp4.ac.uk/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	>=sci-chemistry/ccp4-apps-6.1.2
	sci-chemistry/mosflm
	sci-chemistry/pointless
	>=sci-libs/ccp4-libs-6.1.2
	sci-libs/cctbx"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	find . -name '*.bat' -delete || die

	epatch "${FILESDIR}"/${PV}-fix-syntax.patch
	python_convert_shebangs -r $(python_get_version) .
}

src_install() {
	rm -rf ${P}/binaries ${PN}core-${PV}/Test || die

	insinto /usr/share/ccp4/XIAROOT/
	doins -r * || die

	# Set programs executable
# fperms cannot handle wildcards
	chmod 755 "${ED}"/usr/share/ccp4/XIAROOT/${P}/Applications/* || die
	chmod 644 "${ED}"/usr/share/ccp4/XIAROOT/${P}/Applications/*.py || die

	cat >> "${T}"/23XIA <<- EOF
	XIA2_HOME="${EPREFIX}/usr/share/ccp4/XIAROOT"
	XIA2CORE_ROOT="${EPREFIX}/usr/share/ccp4/XIAROOT/xia2core-${PV}"
	XIA2_ROOT="${EPREFIX}/usr/share/ccp4/XIAROOT/xia2-${PV}"
	PATH="${EPREFIX}/usr/share/ccp4/XIAROOT/xia2-${PV}/Applications"
	EOF

	doenvd "${T}"/23XIA
}

pkg_postinst() {
	python_mod_optimize /usr/share/ccp4/XIAROOT
	echo ""
	elog "In order to use the package, you need to"
	elog "\t source ${EPREFIX}/etc/profile"
	echo ""
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ccp4/XIAROOT
}

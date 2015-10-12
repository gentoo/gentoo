# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils python

DESCRIPTION="An automated data reduction system for crystallography"
HOMEPAGE="http://www.ccp4.ac.uk/xia/"
SRC_URI="http://www.ccp4.ac.uk/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sci-chemistry/ccp4-apps-6.1.2
	sci-chemistry/mosflm
	sci-chemistry/pointless
	>=sci-libs/ccp4-libs-6.1.2
	sci-libs/cctbx"
DEPEND="${RDEPEND}"

src_prepare() {
	find . -name '*.bat' | xargs rm || die

	epatch "${FILESDIR}"/${PV}-fix-syntax.patch
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
	XIA2_HOME="${EPREFIX}"/usr/share/ccp4/XIAROOT
	XIA2CORE_ROOT="${EPREFIX}"/usr/share/ccp4/XIAROOT/xia2core-${PV}
	XIA2_ROOT="${EPREFIX}"/usr/share/ccp4/XIAROOT/xia2-${PV}
	PATH="${EPREFIX}"/usr/share/ccp4/XIAROOT/xia2-${PV}/Applications
	EOF

	doenvd "${T}"/23XIA
}

pkg_postinst() {
	python_mod_optimize /usr/share/ccp4/XIAROOT
}

pkg_postrm() {
	python_mod_cleanup /usr/share/ccp4/XIAROOT
}

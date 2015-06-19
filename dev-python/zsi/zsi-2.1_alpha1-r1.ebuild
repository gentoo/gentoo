# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/zsi/zsi-2.1_alpha1-r1.ebuild,v 1.8 2015/04/08 08:05:18 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="ZSI"
MY_P="${MY_PN}-${PV/_alpha/-a}"

DESCRIPTION="Web Services for Python"
HOMEPAGE="http://pywebsvcs.sourceforge.net/zsi.html"
SRC_URI="mirror://sourceforge/pywebsvcs/${MY_P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc examples twisted"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	twisted? (
		dev-python/twisted-core
		dev-python/twisted-web
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	if ! use twisted; then
		sed -i \
			-e "/version_info/d"\
			-e "/ZSI.twisted/d"\
			setup.py || die "sed failed"
	fi
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dohtml doc/*.{html,css,png}
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r doc/examples/* samples/*
	fi
}

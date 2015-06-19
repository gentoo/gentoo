# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/pbs-python/pbs-python-4.3.3-r1.ebuild,v 1.3 2015/04/08 18:25:44 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P=${P/-/_}

DESCRIPTION="Python bindings to the Torque C API"
HOMEPAGE="https://subtrac.sara.nl/oss/pbs_python/"
SRC_URI="ftp://ftp.sara.nl/pub/outgoing/${MY_P}.tar.gz"

LICENSE="openpbs"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="sys-cluster/torque"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	sed -i -e "s/4.1.3/${PV}/" setup.py.in || die
	distutils-r1_python_prepare_all
}

python_configure_all() {
	econf
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${P}
		doins "${S}"/examples/*
	fi
}

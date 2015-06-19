# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyml/pyml-0.7.13.3.ebuild,v 1.1 2015/06/01 06:20:29 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MYP=PyML-${PV}

DESCRIPTION="Python machine learning package"
HOMEPAGE="http://pyml.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MYP}"

python_test() {
	pushd data > /dev/null
		"${PYTHON}" -c "from PyML.demo import pyml_test; pyml_test.test('svm')" || die "tests failed"
	popd > /dev/null
}

python_install_all() {
	use doc && dodoc doc/tutorial.pdf && dohtml -r doc/autodoc/*
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/json-tools/json-tools-0.3.2.ebuild,v 1.2 2015/04/08 08:04:56 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

MY_PN="json_tools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A set of tools to manipulate JSON: diff, patch, and pretty-printing"
HOMEPAGE="https://pypi.python.org/pypi/json_tools https://bitbucket.org/vadim_semenov/json_tools"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S=${WORKDIR}/${MY_P}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

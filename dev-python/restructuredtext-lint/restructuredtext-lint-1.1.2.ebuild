# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit distutils-r1

DESCRIPTION="Created out of frustration, it sucks to find out your reST is invalid after uploading it."
HOMEPAGE="https://pypi.org/project/restructuredtext_lint"

MY_P="restructuredtext_lint"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_P}/${MY_P}-${PV}.tar.gz"
S="${WORKDIR}/${MY_P}-${PV}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	<dev-python/docutils-1.0[${PYTHON_USEDEP}]"

python_test() {
	 nosetests -v || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 optfeature

DESCRIPTION="Style checker for Sphinx (or other) RST documentation"
HOMEPAGE="http://git.openstack.org/cgit/stackforge/doc8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

RDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/restructuredtext-lint[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
		dev-python/toml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

pkg_postinst() {
	optfeature "checking pyproject.toml projects" dev-python/toml
}

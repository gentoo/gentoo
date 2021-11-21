# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python object model built on JSON schema and JSON patch"
HOMEPAGE="https://github.com/bcwaldon/warlock"
SRC_URI="https://github.com/bcwaldon/${PN}/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/jsonpatch-0.10[${PYTHON_USEDEP}]
	<dev-python/jsonpatch-2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-0.7[${PYTHON_USEDEP}]
	<dev-python/jsonschema-4[${PYTHON_USEDEP}]"

distutils_enable_tests unittest

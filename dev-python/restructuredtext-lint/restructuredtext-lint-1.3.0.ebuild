# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

MY_P="${P/-/_}"
DESCRIPTION="Checks PyPI validity of reStructuredText"
HOMEPAGE="https://pypi.org/project/restructuredtext_lint/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86"

BDEPEND="
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	<dev-python/docutils-1.0[${PYTHON_USEDEP}]"

distutils_enable_tests nose

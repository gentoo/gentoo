# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=pytest-codeblocks-${PV}
DESCRIPTION="Extract code blocks from markdown"
HOMEPAGE="https://github.com/nschloe/pytest-codeblocks/"
SRC_URI="
	https://github.com/nschloe/pytest-codeblocks/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

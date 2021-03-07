# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python docutils-compatibility bridge to CommonMark"
HOMEPAGE="https://recommonmark.readthedocs.io/"
SRC_URI="https://github.com/rtfd/recommonmark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	>=dev-python/commonmark-0.8.1[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.14[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}/${PN}-0.6.0-sphinx3-1.patch"
	"${FILESDIR}/${PN}-0.6.0-sphinx3-2.patch"
)

distutils_enable_tests pytest

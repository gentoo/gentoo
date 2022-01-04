# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=pyproject.toml
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"
HOMEPAGE="https://robpol86.github.io/terminaltables/"
SRC_URI="
	https://github.com/matthewdeanmartin/terminaltables/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	test? (
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/colorclass[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/terminaltables-3.1.0-stdout.patch
)

src_prepare() {
	# workaround pp2sp complaining about unsupported exclude,
	# even though it's empty (fix will be included in pp2sp-22)
	sed -i -e 's:^exclude:empty-&:' pyproject.toml || die
	distutils-r1_src_prepare
}

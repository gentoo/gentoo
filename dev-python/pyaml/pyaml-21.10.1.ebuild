# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYPI_PN="pyaml"

inherit distutils-r1 pypi

DESCRIPTION="PyYAML-based module to produce pretty and readable YAML-serialized data"
HOMEPAGE="https://github.com/mk-fg/pretty-yaml"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~ppc64 ~riscv x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/unidecode[${PYTHON_USEDEP}]
	)"

distutils_enable_tests unittest

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A custom YAML tag for referencing environment variables in YAML files"
HOMEPAGE="https://github.com/waylan/pyyaml-env-tag"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~riscv x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

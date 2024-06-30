# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A custom YAML tag for referencing environment variables in YAML files"
HOMEPAGE="
	https://github.com/waylan/pyyaml-env-tag/
	https://pypi.org/project/pyyaml_env_tag/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

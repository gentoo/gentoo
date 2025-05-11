# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} pypy3_11 )

inherit distutils-r1

DESCRIPTION="A custom YAML tag for referencing environment variables in YAML files"
HOMEPAGE="
	https://github.com/waylan/pyyaml-env-tag/
	https://pypi.org/project/pyyaml_env_tag/
"
# https://github.com/waylan/pyyaml-env-tag/issues/9
SRC_URI="
	https://github.com/waylan/pyyaml-env-tag/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

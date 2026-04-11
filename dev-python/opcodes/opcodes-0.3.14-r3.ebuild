# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

EGIT_COMMIT=0f7c7d63f5e13ce5a89d9acc3934f1b6e247ec1f
MY_P=${PN^}-${EGIT_COMMIT}
DESCRIPTION="Opcodes Project"
HOMEPAGE="
	https://github.com/Maratyszcza/Opcodes/
	https://pypi.org/project/opcodes/
"
SRC_URI="
	https://github.com/Maratyszcza/Opcodes/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/pkg-resources[${PYTHON_USEDEP}]
"

DOCS=( readme.rst )

distutils_enable_sphinx sphinx \
	dev-python/sphinx-bootstrap-theme

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# actually needs pkg-resources
	sed -i -e '/"setuptools"/d' setup.py || die
}

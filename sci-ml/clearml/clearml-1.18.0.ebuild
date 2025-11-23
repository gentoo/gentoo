# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Auto-Magical CI/CD to streamline your AI workload"
HOMEPAGE="https://clear.ml/docs"
SRC_URI="https://github.com/clearml/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-python/pyjwt[${PYTHON_USEDEP}]
	dev-python/furl[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_prepare() {
	find clearml -name "*.py" -exec sed -i 's:pathlib2:pathlib:' {} + || die
	distutils-r1_src_prepare
}

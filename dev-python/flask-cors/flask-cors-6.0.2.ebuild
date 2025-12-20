# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/corydolphin/flask-cors.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/corydolphin/flask-cors/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="A Flask extension for Cross Origin Resource Sharing (CORS)"
HOMEPAGE="
	https://github.com/corydolphin/flask-cors/
	https://pypi.org/project/flask-cors/
"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/flask-0.9[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.7[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

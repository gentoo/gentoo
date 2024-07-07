# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/corydolphin/flask-cors.git"
	inherit git-r3
else
	SRC_URI="
		https://github.com/corydolphin/flask-cors/archive/${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
fi

DESCRIPTION="A Flask extension for Cross Origin Resource Sharing (CORS)"
HOMEPAGE="
	https://github.com/corydolphin/flask-cors/
	https://pypi.org/project/Flask-Cors/
"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx-rtd-theme \
	dev-python/sphinxcontrib-httpdomain

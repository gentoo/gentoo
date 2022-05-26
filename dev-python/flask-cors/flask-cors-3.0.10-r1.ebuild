# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/wcdolphin/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/corydolphin/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="A Flask extension for Cross Origin Resource Sharing (CORS)"
HOMEPAGE="https://github.com/wcdolphin/flask-cors https://pypi.org/project/Flask-Cors/"

LICENSE="MIT"
SLOT="0"

BDEPEND="test? ( dev-python/packaging[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/sphinx_rtd_theme \
	dev-python/sphinxcontrib-httpdomain

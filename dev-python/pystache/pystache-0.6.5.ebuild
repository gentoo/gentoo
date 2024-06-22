# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Updated Python implementation of Mustache templating framework"
HOMEPAGE="
	https://github.com/PennyDreadfulMTG/pystache/
	https://pypi.org/project/pystache/
"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/PennyDreadfulMTG/pystache.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="
		https://github.com/PennyDreadfulMTG/pystache/archive/v${PV}.tar.gz
			-> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

distutils_enable_sphinx \
	docs/source \
	dev-python/sphinx-rtd-theme \
	dev-python/recommonmark \
	dev-python/sphinxcontrib-apidoc

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	sed -i '/sphinx_git/d' "${S}"/setup.cfg "${S}"/docs/source/conf.py
	default
}

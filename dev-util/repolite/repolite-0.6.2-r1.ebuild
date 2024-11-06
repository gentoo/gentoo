# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 optfeature

DESCRIPTION="Manage a small set of git repository dependencies with YAML"
HOMEPAGE="https://github.com/sarnold/repolite"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/repolite.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/sarnold/repolite/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"
# tests use git_dummy python package which is not packaged
# https://github.com/initialcommit-com/git-dummy
RESTRICT="test"

RDEPEND="
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	dev-vcs/git
"
# needs versioningit if building from git repo source
if [[ ${PV} = 9999* ]]; then
	BDEPEND="$(python_gen_any_dep '>=dev-python/versioningit-2.0.1[${PYTHON_USEDEP}]')"
fi

DOCS=( README.rst )

distutils_enable_sphinx \
	docs/source \
	dev-python/sphinx-rtd-theme \
	dev-python/recommonmark \
	dev-python/sphinxcontrib-apidoc

pkg_postinst() {
	optfeature "initialize repos with lfs files" dev-vcs/git-lfs
}

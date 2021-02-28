# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1 git-r3

DESCRIPTION="A New Arch Tester Toolkit -- open-source stable-bot replacement"
HOMEPAGE="https://github.com/mgorny/nattka/"
EGIT_REPO_URI="https://github.com/mgorny/nattka.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="depgraph-order"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-util/pkgcheck[${PYTHON_USEDEP}]
	dev-vcs/git
	sys-apps/pkgcore[${PYTHON_USEDEP}]
	depgraph-order? (
		dev-python/networkx[${PYTHON_USEDEP}]
	)"
BDEPEND="
	test? (
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/vcrpy[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx doc --no-autodoc
distutils_enable_tests pytest

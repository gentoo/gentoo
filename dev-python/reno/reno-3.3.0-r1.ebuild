# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Release notes manager, storing release notes in a git repo and building docs"
HOMEPAGE="https://pypi.org/project/reno"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc64 ~x86"

RDEPEND="
	>=dev-python/docutils-0.11[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.4[${PYTHON_USEDEP}]
	dev-python/pbr[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-5.3.1[${PYTHON_USEDEP}]
	>=dev-python/sphinx-2.1.1[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/pbr[${PYTHON_USEDEP}]
	test? (
		>=dev-python/testtools-1.4.0[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

#distutils_enable_sphinx doc/source dev-python/openstackdocstheme
distutils_enable_tests unittest

src_prepare() {
	#it want a git repo
	if use test; then
		git init || die
		git config --global user.email "you@example.com" || die
		git config --global user.name "Your Name" || die
		git add . || die
		git commit -m 'init' || die
	fi
	default
}

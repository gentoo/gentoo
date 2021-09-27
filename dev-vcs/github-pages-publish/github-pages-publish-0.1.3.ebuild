# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A script that commits files from a directory to Github Pages"
HOMEPAGE="https://pypi.org/project/github-pages-publish/
	https://github.com/rafaelmartins/github-pages-publish"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pygit2-0.20.0"

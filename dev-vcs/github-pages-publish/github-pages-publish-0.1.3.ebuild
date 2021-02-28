# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{7,8} )

GIT_ECLASS=
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="https://github.com/rafaelmartins/${PN}.git"
fi

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="A script that commits files from a directory to Github Pages"
HOMEPAGE="https://pypi.org/project/github-pages-publish/
	https://github.com/rafaelmartins/github-pages-publish"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-python/pygit2-0.20.0"
RDEPEND="${DEPEND}"

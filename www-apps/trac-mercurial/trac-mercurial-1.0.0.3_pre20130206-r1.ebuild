# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 mercurial

MY_PN="TracMercurial"
MY_P="${MY_PN}-${PV/_pre/dev-r}"

DESCRIPTION="A Mercurial plugin for Trac"
HOMEPAGE="http://trac.edgewall.org/"
EHG_REPO_URI="https://hg.edgewall.org/trac/mercurial-plugin"
EHG_REVISION="8df754d9b36a"

LICENSE="GPL-2"
SLOT="0"
# KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=www-apps/trac-1.0[${PYTHON_USEDEP}]
		>=dev-vcs/mercurial-1.1[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

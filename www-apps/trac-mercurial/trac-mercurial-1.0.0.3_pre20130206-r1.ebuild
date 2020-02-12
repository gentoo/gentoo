# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DISTUTILS_SINGLE_IMPL=1
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

RDEPEND=">=www-apps/trac-1.0[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-vcs/mercurial-1.1[${PYTHON_MULTI_USEDEP}]
	')"

S="${WORKDIR}/${MY_P}"

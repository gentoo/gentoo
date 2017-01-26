# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

#if LIVE
EGIT_REPO_URI="https://bitbucket.org/mgorny/${PN}.git"
inherit git-r3
#endif

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="https://bitbucket.org/mgorny/gpyutils/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-portage/gentoopm-0.2.9[${PYTHON_USEDEP}]"
#if LIVE

KEYWORDS=
SRC_URI=
#endif

python_test() {
	esetup.py test
}

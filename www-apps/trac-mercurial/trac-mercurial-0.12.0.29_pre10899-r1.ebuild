# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="TracMercurial"
MY_P="${MY_PN}-${PV/_pre/dev-r}"

DESCRIPTION="A Mercurial plugin for Trac"
HOMEPAGE="http://trac.edgewall.org/"
SRC_URI="https://dev.gentoo.org/~rafaelmartins/distfiles/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=www-apps/trac-0.12[${PYTHON_USEDEP}]
	>=dev-vcs/mercurial-1.1[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_P}"

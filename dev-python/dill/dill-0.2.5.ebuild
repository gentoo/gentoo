# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{3,4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Serialize all of python (almost)"
HOMEPAGE="http://www.cacr.caltech.edu/~mmckerns/dill.htm"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-avoid-installation-binaries.patch"
	"${FILESDIR}/${P}-remove-install_requires.patch"
)

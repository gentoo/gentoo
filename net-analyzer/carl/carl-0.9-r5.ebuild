# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_7 python3_8 python3_9 pypy3)

inherit distutils-r1

DESCRIPTION="An rsync logfile analyzer"
HOMEPAGE="https://www.schwarzvogel.de/software/misc/"
SRC_URI="https://www.schwarzvogel.de/pkgs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86"

DOCS="README"

src_prepare() {
	sed -i -e "s|(__version__)|\"${PVR}\"|g" setup.py || die
	default
}

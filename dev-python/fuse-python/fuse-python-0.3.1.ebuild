# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python FUSE bindings"
HOMEPAGE="https://github.com/libfuse/python-fuse"
SRC_URI="https://github.com/libfuse/python-fuse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-fs/fuse:0="

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/python-fuse-${PV}"

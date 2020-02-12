# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

KEYWORDS="amd64 x86"
DESCRIPTION="Python FUSE bindings"
HOMEPAGE="https://github.com/libfuse/python-fuse"

SRC_URI="mirror://sourceforge/fuse/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=sys-fs/fuse-2.0"
DEPEND="${RDEPEND}"

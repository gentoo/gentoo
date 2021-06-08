# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Python ctypes-based bindings for libvlc"
HOMEPAGE="https://github.com/oaubert/python-vlc
	https://wiki.videolan.org/Python_bindings/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-video/vlc
"

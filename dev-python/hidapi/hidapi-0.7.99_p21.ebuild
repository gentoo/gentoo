# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit distutils-r1

MY_P="${P/_p/.post}"

DESCRIPTION="Python wrapper for dev-libs/hidapi"
HOMEPAGE="https://trezor.io"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/hidapi
	virtual/libusb:1"
DEPEND="${RDEPEND}
	>=dev-python/cython-0.24.0"

S="${WORKDIR}/${MY_P}"

src_configure() {
	mydistutilsargs=(
		--with-system-hidapi
	)
}

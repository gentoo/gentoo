# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python interface for libuv"
HOMEPAGE="https://pyuv.readthedocs.org/en"
SRC_URI="https://github.com/saghul/pyuv/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# https://github.com/saghul/pyuv/blob/v1.x/setup_libuv.py#L117
RDEPEND=">=dev-libs/libuv-1.7.3:0/1"
DEPEND="${RDEPEND}"

S="${WORKDIR}/pyuv-pyuv-${PV}"

src_configure() {
	mydistutilsargs=( build_ext --use-system-libuv )
	distutils-r1_src_configure
}

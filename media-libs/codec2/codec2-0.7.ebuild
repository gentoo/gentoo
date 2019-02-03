# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Low bit rate speech codec"
HOMEPAGE="https://freedv.org/"
SRC_URI="https://freedv.com/wp-content/uploads/sites/8/2017/10/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

multilib_src_configure() {
	local mycmakeargs=( -DUNITTEST=OFF )
	cmake-utils_src_configure
}

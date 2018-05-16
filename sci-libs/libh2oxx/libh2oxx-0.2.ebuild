# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit autotools-utils

DESCRIPTION="C++ bindings for libh2o"
HOMEPAGE="https://github.com/mgorny/libh2oxx/"
SRC_URI="https://github.com/mgorny/libh2oxx/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug static-libs"

RDEPEND=">=sci-libs/libh2o-0.2"
DEPEND="${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
	)

	autotools-utils_src_configure
}

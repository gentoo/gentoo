# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU Spread Sheet Widget"
HOMEPAGE="https://www.gnu.org/software/ssw/"
SRC_URI="https://alpha.gnu.org/gnu/ssw/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/glib
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/glib-utils"

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

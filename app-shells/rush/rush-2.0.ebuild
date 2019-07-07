# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Restricted User Shell"
HOMEPAGE="https://puszcza.gnu.org.ua/projects/rush/"
SRC_URI="ftp://download.gnu.org.ua/pub/release/${PN}/${P}.tar.xz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"

IUSE="nls"

BDEPEND="
	nls? ( sys-devel/gettext )
"

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C PreProcessor directive Indenter"
HOMEPAGE="https://www.gnu.org/software/cppi"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND="
	app-arch/xz-utils
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS ChangeLog NEWS README{,-release} THANKS TODO )

PATCHES=( "${FILESDIR}"/${PN}-1.18_do-not-fortify-source.patch )

src_configure() {
	autoreconf # because patches changed configure.ac
	econf $(use_enable nls)
}

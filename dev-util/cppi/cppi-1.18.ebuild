# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a cpp directive indenter"
HOMEPAGE="https://savannah.gnu.org/projects/cppi"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

DEPEND="
	app-arch/xz-utils
	nls? ( sys-devel/gettext )
"

DOCS=( AUTHORS ChangeLog NEWS THANKS TODO )

src_configure() {
	econf $(use_enable nls)
}

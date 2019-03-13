# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/enlightenment-/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="An app for downloading themes and add-ons to Enlightenment WM"
HOMEPAGE="https://extra.enlightenment.org"
SRC_URI="https://download.enlightenment.org/rel/apps/${MY_PN}/${MY_P}.tar.xz -> ${P}.tar.xz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND=">=dev-libs/efl-1.18[X]"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
"

S="${WORKDIR}"/"${MY_P}"

src_prepare() {
	default

	# Fix a QA issue, https://phab.enlightenment.org/T7167
	sed -i '/Version=/d' data/desktop/extra.desktop* || die
}

src_configure() {
	local myconf=(
		$(use_enable nls)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

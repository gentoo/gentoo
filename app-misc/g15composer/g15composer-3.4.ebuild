# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A library to render text and shapes into a buffer usable by the Logitech G15"
HOMEPAGE="https://gitlab.com/menelkir/g15composer"
if [[ ${PV} == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/menelkir/g15composer.git"
else
	SRC_URI="https://gitlab.com/menelkir/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="truetype"

DEPEND="
	>=app-misc/g15daemon-3.0
	>=dev-libs/libg15render-3.0[truetype?]
	truetype? ( media-libs/freetype	)
"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable truetype ttf)
}

src_install() {
	local DOCS=( AUTHORS README ChangeLog )
	default

	newinitd "${FILESDIR}/${PN}-3.2.initd" ${PN}
	newconfd "${FILESDIR}/${PN}-3.2.confd" ${PN}
}

pkg_postinst() {
	elog "Set the user to run g15composer in /etc/conf.d/g15composer before starting the service."
}

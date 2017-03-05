# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools

MY_P="${PN/-/_}_${PV//./_}"

DESCRIPTION="CLI designed to validate AppData descriptions for standards compliance and to the style guide"
HOMEPAGE="https://github.com/hughsie/appdata-tools/"
SRC_URI="https://github.com/hughsie/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="nls"

RDEPEND=">=dev-libs/glib-2.14
	>=net-libs/libsoup-2.4
	>=x11-libs/gdk-pixbuf-2.0"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.3
	dev-libs/libxslt
	nls? ( >=dev-util/intltool-0.35.0
		sys-devel/gettext )"

S="${WORKDIR}/${PN}-${MY_P}"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--enable-man \
		--disable-schemas
}

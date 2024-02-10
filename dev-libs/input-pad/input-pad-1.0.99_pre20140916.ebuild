# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

MY_P="${P/_pre/.}"
MY_PV="${PV/_pre/.}"

DESCRIPTION="On-screen input pad to send characters with mouse"
HOMEPAGE="https://github.com/fujiwarat/input-pad/wiki"
SRC_URI="https://github.com/fujiwarat/${PN}/releases/download/${MY_PV}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="eekboard +introspection static-libs +xtest"

RDEPEND="dev-libs/glib:2
	dev-libs/libxml2
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libxkbfile
	x11-libs/libxklavier
	virtual/libintl
	eekboard? ( dev-libs/eekboard )
	introspection? ( dev-libs/gobject-introspection )
	xtest? ( x11-libs/libXtst )"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-Wreturn-type.patch
	"${FILESDIR}"/${PN}-man.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable eekboard eek) \
		$(use_enable introspection) \
		$(use_enable static-libs static) \
		$(use_enable xtest)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete || die
}

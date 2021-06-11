# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-1 )
LUA_REQ_USE="deprecated"

inherit autotools lua-single

DESCRIPTION="Library for parsing video download links"
HOMEPAGE="http://quvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/quvi/${PV:0:3}/${P}.tar.xz"

LICENSE="AGPL-3"
SLOT="0/8" # subslot = libquvi soname version
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ppc64 sparc x86"
IUSE="examples nls static-libs"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	>=dev-libs/glib-2.34.3:2
	>=dev-libs/libgcrypt-1.5.3:0=
	>=media-libs/libquvi-scripts-0.9.20130903[${LUA_SINGLE_USEDEP}]
	!<media-libs/quvi-0.4.0
	>=net-libs/libproxy-0.4.11-r1
	>=net-misc/curl-7.36.0
	nls? ( >=virtual/libintl-0-r1 )
"

DEPEND="${RDEPEND}"

BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.1-headers-reinstall.patch
	"${FILESDIR}"/${PN}-0.9.4-autoconf-2.70.patch #749816
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--with-manual
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	einstalldocs
	use examples && dodoc -r examples

	find "${ED}" -name '*.la' -delete || die
}

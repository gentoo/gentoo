# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"

inherit autotools flag-o-matic wxwidgets xdg

MY_PV="${PV/_/-}"
MY_P="FileZilla_${MY_PV}"

DESCRIPTION="FTP client with lots of useful features and an intuitive interface"
HOMEPAGE="https://filezilla-project.org/"
SRC_URI="https://download.filezilla-project.org/client/${MY_P}_src.tar.bz2"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE="dbus nls test"
RESTRICT="!test? ( test )"

# pugixml 1.7 minimal dependency is for c++11 proper configuration
RDEPEND="
	>=app-eselect/eselect-wxwidgets-0.7-r1
	>=dev-libs/nettle-3.1:=
	>=dev-db/sqlite-3.7
	>=dev-libs/libfilezilla-0.30.0:=
	>=dev-libs/pugixml-1.7
	>=net-libs/gnutls-3.5.7
	>=x11-libs/wxGTK-3.0.4:${WX_GTK_VER}[X]
	x11-misc/xdg-utils
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cppunit-1.13.0 )"
BDEPEND="
	virtual/pkgconfig
	>=sys-devel/libtool-1.4
	nls? ( >=sys-devel/gettext-0.11 )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.22.1-debug.patch
	"${FILESDIR}"/${PN}-3.47.0-metainfo.patch
	"${FILESDIR}"/${PN}-3.47.0-disable-shellext_conf.patch
	"${FILESDIR}"/${PN}-3.52.2-slibtool.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	setup-wxwidgets

	local myeconfargs=(
		--disable-autoupdatecheck
		--with-pugixml=system
		$(use_enable nls locales)
		$(use_with dbus)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0-gtk3"

inherit autotools flag-o-matic wxwidgets xdg

MY_PV=${PV/_/-}
MY_P="FileZilla_${MY_PV}"

DESCRIPTION="FTP client with lots of useful features and an intuitive interface"
HOMEPAGE="https://filezilla-project.org/"
SRC_URI="https://download.filezilla-project.org/client/${MY_P}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE="dbus nls test"

# pugixml 1.7 minimal dependency is for c++11 proper configuration
RDEPEND=">=app-eselect/eselect-wxwidgets-0.7-r1
	>=dev-libs/nettle-3.1:=
	>=dev-db/sqlite-3.7
	>=dev-libs/libfilezilla-0.21.0:=
	<dev-libs/libfilezilla-0.22.0:=
	>=dev-libs/pugixml-1.7
	>=net-libs/gnutls-3.5.7
	>=x11-libs/wxGTK-3.0.4:${WX_GTK_VER}[X]
	x11-misc/xdg-utils
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/libtool-1.4
	nls? ( >=sys-devel/gettext-0.11 )
	test? ( >=dev-util/cppunit-1.13.0 )"

RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${MY_PV}

DOCS=(AUTHORS ChangeLog NEWS )

PATCHES=(
	"${FILESDIR}"/${PN}-3.22.1-debug.patch
	"${FILESDIR}"/${PN}-3.47.0-metainfo.patch
	"${FILESDIR}"/${PN}-3.47.0-disable-shellext_conf.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! test-flag-CXX -std=c++14; then
			eerror "${P} requires C++14-capable C++ compiler. Your current compiler"
			eerror "does not seem to support -std=c++14 option. Please upgrade your compiler"
			eerror "to gcc-4.9 or an equivalent version supporting C++14."
			die "Currently active compiler does not support -std=c++14"
		fi
	fi
}

src_prepare() {
	setup-wxwidgets
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-autoupdatecheck
		--with-pugixml=system
		$(use_enable nls locales)
		$(use_with dbus)
	)
	econf "${myeconfargs[@]}"
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}

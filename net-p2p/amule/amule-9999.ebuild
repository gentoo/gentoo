# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit cmake flag-o-matic wxwidgets xdg-utils

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/amule-project/amule"
	inherit git-r3
else
	MY_P="${PN/m/M}-${PV}"
	SRC_URI="https://download.sourceforge.net/${PN}/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~alpha ~amd64 ~arm ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

DESCRIPTION="aMule, the all-platform eMule p2p client"
HOMEPAGE="https://www.amule.org/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="daemon debug geoip +gui nls remote stats test upnp"
REQUIRED_USE="|| ( daemon gui remote )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/crypto++:=
	sys-libs/binutils-libs:0=
	sys-libs/readline:0=
	virtual/zlib:=
	x11-libs/wxGTK:${WX_GTK_VER}=[curl]
	daemon? (
		acct-user/amule
		dev-libs/boost:=
	)
	gui? (
		dev-libs/boost:=
		x11-libs/wxGTK:${WX_GTK_VER}=[X]
		geoip? ( dev-libs/geoip )
	)
	nls? ( virtual/libintl )
	remote? (
		acct-user/amule
		media-libs/libpng:0=
	)
	stats? ( media-libs/gd:=[jpeg,png] )
	upnp? ( net-libs/libupnp:0= )
"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.0-disable-version-check.patch"
	"${FILESDIR}/${PN}-2.4.0-use-xdg-open-as-preview-default.patch"
)

src_configure() {
	setup-wxwidgets

	use debug || append-cppflags -DwxDEBUG_LEVEL=0
	CMAKE_BUILD_TYPE=$(usex debug Debug ${CMAKE_BUILD_TYPE})

	local mycmakeargs=(
		-DBUILD_ALCC=YES
		-DBUILD_ED2K=YES
		-DBUILD_ALC="$(usex gui)"
		-DBUILD_AMULECMD="$(usex remote)"
		-DBUILD_DAEMON="$(usex daemon)"
		-DBUILD_CAS="$(usex stats)"
		-DBUILD_MONOLITHIC="$(usex gui)"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_WEBSERVER="$(usex remote)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_UPNP="$(usex upnp)"
	)

	if use gui; then
		mycmakeargs+=(
			-DBUILD_REMOTEGUI="$(usex remote)"
			-DBUILD_WXCAS="$(usex stats)"
			-DENABLE_IP2COUNTRY="$(usex geoip)"
		)
	else
		mycmakeargs+=(
			-DBUILD_REMOTEGUI=NO
			-DBUILD_WXCAS=NO
			-DENABLE_IP2COUNTRY=NO
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use daemon; then
		newconfd "${FILESDIR}"/amuled.confd-r1 amuled
		newinitd "${FILESDIR}"/amuled.initd amuled
	fi
	if use remote; then
		newconfd "${FILESDIR}"/amuleweb.confd-r1 amuleweb
		newinitd "${FILESDIR}"/amuleweb.initd amuleweb
	fi

	if use daemon || use remote; then
		keepdir /var/lib/${PN}
		fowners amule:amule /var/lib/${PN}
		fperms 0750 /var/lib/${PN}
	fi
}

pkg_postinst() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postrm() {
	if use gui; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

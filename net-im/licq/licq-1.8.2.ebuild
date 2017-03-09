# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils flag-o-matic

DESCRIPTION="ICQ Client with v8 support"
HOMEPAGE="http://www.licq.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="debug doc l10n_he nls socks5 ssl xosd aosd xmpp qt4 msn"

RDEPEND="
	>=app-crypt/gpgme-1
	app-text/hunspell
	dev-libs/boost:=
	x11-libs/libXScrnSaver
	xmpp? ( net-libs/gloox )
	qt4? ( dev-qt/qtgui:4 )
	socks5? ( net-proxy/dante )
	ssl? ( >=dev-libs/openssl-0.9.5a:0= )
	xosd? ( x11-libs/xosd )
	aosd? ( x11-libs/libaosd )
"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	local licq_plugins=(
		auto-reply
		icq
		rms
		$(usex aosd aosd '')
		$(usex msn msn '')
		$(usex qt4 qt4-gui '')
		$(usex xmpp jabber '')
		$(usex xosd osd '')
	)

	local plugins=() x
	for x in ${licq_plugins[@]} ; do
		plugins+=( ${x}/CMakeLists.txt )
	done

	# somehow sed doesn't like an array variable
	x="${plugins[@]}"
	sed -e "s|file(GLOB cmake_plugins.*$|set(cmake_plugins ${x})|" \
		-i plugins/CMakeLists.txt || die
}

pkg_setup() {
	# crutch
	append-flags -pthread
}

src_configure() {
	mycmakeargs=(
		-DBUILD_PLUGINS=ON
		-DBUILD_TESTS=OFF
		-DCMAKE_BUILD_TYPE="$(usex debug 'Debug' 'Release')"
		-DENABLE_NLS="$(usex nls)"
		-DUSE_DOXYGEN="$(usex doc)"
		-DUSE_FIFO=ON
		-DUSE_HEBREW="$(usex l10n_he)"
		-DUSE_OPENSSL="$(usex ssl)"
		-DUSE_SOCKS5="$(usex socks5)"
	)

	cmake-utils_src_configure
}

src_install() {
	local DOCS=( README )
	cmake-utils_src_install

	docinto doc
	dodoc doc/*

	use ssl && dodoc README.OPENSSL

	exeinto /usr/share/${PN}/upgrade
	doexe upgrade/*.pl
}

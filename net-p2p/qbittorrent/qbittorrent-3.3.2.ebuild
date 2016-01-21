# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 qt4-r2 flag-o-matic

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="http://www.qbittorrent.org/"

MY_P=${P/_}
if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus debug qt4 +qt5 webui +X"
REQUIRED_USE="
	^^ ( qt4 qt5 )
	dbus? ( X )
"

CDEPEND="
	dev-libs/boost:=
	>=dev-qt/qtsingleapplication-2.6.1_p20130904-r1[qt4?,qt5?,X?]
	>=net-libs/rb_libtorrent-1.0.6
	sys-libs/zlib
	qt4? (
		dev-qt/qtcore:4
		dbus? ( dev-qt/qtdbus:4 )
		X? ( dev-qt/qtgui:4 )
	)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtxml:5
		dbus? ( dev-qt/qtdbus:5 )
		X? ( dev-qt/qtgui:5
			dev-qt/qtwidgets:5 )
	)
"
DEPEND="${CDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	${PYTHON_DEPS}"

S=${WORKDIR}/${MY_P}
DOCS=(AUTHORS Changelog README.md TODO)

src_prepare() {
	epatch_user
	qt4-r2_src_prepare
}

src_configure() {
	# See bug 569062
	append-cppflags "-DBOOST_NO_CXX11_REF_QUALIFIERS"

	# Custom configure script, econf fails
	local myconf=(
		./configure
		--prefix="${EPREFIX}/usr"
		--with-qtsingleapplication=system
		$(use dbus  || echo --disable-qt-dbus)
		$(use debug && echo --enable-debug)
		$(use qt4   && echo --with-qt4)
		$(use webui || echo --disable-webui)
		$(use X     || echo --disable-gui)
	)

	echo "${myconf[@]}"
	"${myconf[@]}" || die "configure failed"
	use qt4 && eqmake4
	use qt5 && eqmake5
}

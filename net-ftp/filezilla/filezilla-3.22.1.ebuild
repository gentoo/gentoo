# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="3.0"

inherit autotools eutils flag-o-matic multilib wxwidgets

MY_PV=${PV/_/-}
MY_P="FileZilla_${MY_PV}"

DESCRIPTION="FTP client with lots of useful features and an intuitive interface"
HOMEPAGE="http://filezilla-project.org/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}_src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="dbus nls test"

# pugixml 1.7 minimal dependency is for c++11 proper configuration
RDEPEND=">=app-eselect/eselect-wxwidgets-0.7-r1
	>=dev-libs/nettle-3.1:=
	>=dev-db/sqlite-3.7
	>=dev-libs/libfilezilla-0.7.0
	>=dev-libs/pugixml-1.7
	net-dns/libidn
	>=net-libs/gnutls-3.4.0
	>=x11-libs/wxGTK-3.0.2.0-r1:3.0[X] x11-misc/xdg-utils
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/libtool-1.4
	nls? ( >=sys-devel/gettext-0.11 )
	test? ( dev-util/cppunit )"

S="${WORKDIR}"/${PN}-${MY_PV}

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
	epatch "${FILESDIR}"/${PN}-3.22.1-debug.patch
	eautoreconf
}

src_configure() {
	econf $(use_with dbus) $(use_enable nls locales) \
		--with-pugixml=system \
		--disable-autoupdatecheck
}

src_install() {
	emake DESTDIR="${D}" install

	doicon src/interface/resources/48x48/${PN}.png

	dodoc AUTHORS ChangeLog NEWS
}

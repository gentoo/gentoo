# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/filezilla/filezilla-3.11.0.1.ebuild,v 1.1 2015/05/22 15:45:33 voyageur Exp $

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
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="aqua dbus nls test"

RDEPEND=">=app-eselect/eselect-wxwidgets-0.7-r1
	>=dev-db/sqlite-3.7
	>=dev-libs/tinyxml-2.6.1-r1[stl]
	net-dns/libidn
	>=net-libs/gnutls-3.1.12
	aqua? ( >=x11-libs/wxGTK-3.0.2.0-r1:3.0[aqua] )
	!aqua? ( >=x11-libs/wxGTK-3.0.2.0-r1:3.0[X] x11-misc/xdg-utils )
	dbus? ( sys-apps/dbus )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/libtool-1.4
	nls? ( >=sys-devel/gettext-0.11 )
	test? ( dev-util/cppunit )"

S="${WORKDIR}"/${PN}-${MY_PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.10.2-debug.patch
	append-cppflags -DTIXML_USE_STL
	eautoreconf
}

src_configure() {
	econf $(use_with dbus) $(use_enable nls locales) \
		--with-tinyxml=system \
		--disable-autoupdatecheck
}

src_install() {
	emake DESTDIR="${D}" install

	doicon src/interface/resources/48x48/${PN}.png

	dodoc AUTHORS ChangeLog NEWS

	if use aqua ; then
		cat > "${T}/${PN}" <<-EOF
			#!${EPREFIX}/bin/bash
			open "${EPREFIX}"/Applications/FileZilla.app
		EOF
		rm "${ED}/usr/bin/${PN}" || die
		dobin "${T}/${PN}"
		insinto /Applications
		doins -r "${S}"/FileZilla.app
	fi
}

# Copyright 1999-2015 Gentoo Foundation
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
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux ~x86-macos"
IUSE="aqua dbus nls test"

RDEPEND=">=app-eselect/eselect-wxwidgets-0.7-r1
	>=dev-db/sqlite-3.7
	net-dns/libidn
	>=net-libs/gnutls-3.1.12
	aqua? ( >=x11-libs/wxGTK-3.0.2.0-r1:3.0[aqua] )
	!aqua? ( >=x11-libs/wxGTK-3.0.2.0-r1:3.0[X] x11-misc/xdg-utils )
	dbus? ( sys-apps/dbus )"
#	>=dev-libs/pugixml-1.5
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=sys-devel/libtool-1.4
	nls? ( >=sys-devel/gettext-0.11 )
	test? ( dev-util/cppunit )"

S="${WORKDIR}"/${PN}-${MY_PV}

src_prepare() {
	# Missing in tarball
	cp -a "${FILESDIR}"/${P}-fzputtygen_interface.h \
		src/interface/fzputtygen_interface.h || die
	epatch "${FILESDIR}"/${PN}-3.10.2-debug.patch
	eautoreconf
}

src_configure() {
	# Does not build with system pugixml, use builtin for now
	econf $(use_with dbus) $(use_enable nls locales) \
		--with-pugixml=builtin \
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

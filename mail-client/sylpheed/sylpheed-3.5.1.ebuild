# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION="A lightweight email client and newsreader"
HOMEPAGE="http://sylpheed.sraoss.jp/"
SRC_URI="http://${PN}.sraoss.jp/${PN}/v${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="crypt ipv6 ldap libressl nls oniguruma pda spell ssl xface"

CDEPEND="x11-libs/gtk+:2
	crypt? ( app-crypt/gpgme )
	ldap? ( net-nds/openldap )
	nls? ( sys-devel/gettext )
	oniguruma? ( dev-libs/oniguruma )
	pda? ( app-pda/jpilot )
	spell? ( app-text/gtkspell:2 )
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)"
RDEPEND="${CDEPEND}
	app-misc/mime-types
	net-misc/curl"
DEPEND="${CDEPEND}
	virtual/pkgconfig
	xface? ( media-libs/compface )"

src_configure() {
	local htmldir=/usr/share/doc/${PF}/html
	econf \
		$(use_enable crypt gpgme) \
		$(use_enable ipv6) \
		$(use_enable ldap) \
		$(use_enable oniguruma) \
		$(use_enable pda jpilot) \
		$(use_enable spell gtkspell) \
		$(use_enable ssl) \
		$(use_enable xface compface) \
		--with-plugindir=/usr/$(get_libdir)/${PN}/plugins \
		--with-manualdir=${htmldir}/manual \
		--with-faqdir=${htmldir}/faq \
		--disable-updatecheck
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* NEWS* PLUGIN* README* TODO*

	doicon *.png
	domenu *.desktop

	cd plugin/attachment_tool
	emake DESTDIR="${D}" install-plugin
	docinto plugin/attachment_tool
	dodoc README
}

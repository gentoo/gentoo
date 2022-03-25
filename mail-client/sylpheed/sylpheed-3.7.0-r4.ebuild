# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit desktop xdg

DESCRIPTION="A lightweight email client and newsreader"
HOMEPAGE="http://sylpheed.sraoss.jp/"
SRC_URI="http://${PN}.sraoss.jp/${PN}/v${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="crypt ipv6 ldap nls oniguruma spell ssl xface"

CDEPEND="net-libs/liblockfile
	x11-libs/gtk+:2
	crypt? ( app-crypt/gpgme:= )
	ldap? ( net-nds/openldap:= )
	nls? ( sys-devel/gettext )
	oniguruma? ( dev-libs/oniguruma:= )
	spell? (
		app-text/gtkspell:2
		dev-libs/dbus-glib
	)
	ssl? (
		dev-libs/openssl:0=
	)"
RDEPEND="${CDEPEND}
	app-misc/mime-types
	net-misc/curl"
DEPEND="${CDEPEND}
	xface? ( media-libs/compface )"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-tls-1.3.patch )
DOCS="AUTHORS ChangeLog* NEW* PLUGIN* README* TODO*"

src_configure() {
	local htmldir="${EPREFIX}"/usr/share/doc/${PF}/html
	econf \
		$(use_enable crypt gpgme) \
		$(use_enable ipv6) \
		$(use_enable ldap) \
		$(use_enable oniguruma) \
		$(use_enable spell gtkspell) \
		$(use_enable ssl) \
		$(use_enable xface compface) \
		--with-plugindir="${EPREFIX}"/usr/$(get_libdir)/${PN}/plugins \
		--with-manualdir="${htmldir}"/manual \
		--with-faqdir="${htmldir}"/faq \
		--disable-updatecheck
}

src_install() {
	default

	doicon *.png
	domenu *.desktop

	cd plugin/attachment_tool
	emake DESTDIR="${D}" install-plugin
	docinto plugin/attachment_tool
	dodoc README
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils git-r3 libtool

DESCRIPTION="A sophisticated ftp/sftp/http/https/torrent client and file transfer program"
HOMEPAGE="http://lftp.tech/"
EGIT_REPO_URI="https://github.com/lavv17/lftp"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

IUSE="convert-mozilla-cookies +gnutls idn ipv6 libressl nls socks5 +ssl verify-file"
LFTP_LINGUAS=( cs de es fr it ja ko pl pt_BR ru uk zh_CN zh_HK zh_TW )
IUSE+=" ${LFTP_LINGUAS[@]/#/linguas_}"

RDEPEND="
	>=sys-libs/ncurses-5.1:=
	>=sys-libs/readline-5.1:=
	dev-libs/expat
	sys-libs/zlib
	convert-mozilla-cookies? ( dev-perl/DBI )
	idn? ( net-dns/libidn )
	socks5? (
		>=net-proxy/dante-1.1.12
		virtual/pam
	)
	ssl? (
		gnutls? ( >=net-libs/gnutls-1.2.3:0= )
		!gnutls? (
			!libressl? ( dev-libs/openssl:0= )
			libressl? ( dev-libs/libressl:0= )
		)
	)
	verify-file? (
		dev-perl/String-CRC32
		virtual/perl-Digest-MD5
	)
"

DEPEND="
	${RDEPEND}
	dev-libs/gnulib
	=sys-devel/libtool-2*
	app-arch/xz-utils
	nls? ( >=sys-devel/gettext-0.19 )
	virtual/pkgconfig
"

DOCS=(
	BUGS ChangeLog FAQ FEATURES MIRRORS NEWS README README.debug-levels
	README.dnssec README.modules THANKS TODO
)
PATCHES=(
	"${FILESDIR}"/${PN}-4.5.5-am_config_header.patch
)

src_prepare() {
	default

	gnulib-tool --update || die

	chmod +x build-aux/git-version-gen || die

	eautoreconf
	elibtoolize # for Darwin bundles
}

src_configure() {
	econf \
		$(use_enable ipv6) \
		$(use_enable nls) \
		$(use_with idn libidn) \
		$(use_with socks5 socksdante "${EPREFIX}"/usr) \
		$(usex ssl "$(use_with !gnutls openssl ${EPREFIX}/usr)" '--without-openssl') \
		$(usex ssl "$(use_with gnutls)" '--without-gnutls') \
		--enable-packager-mode \
		--sysconfdir="${EPREFIX}"/etc/${PN} \
		--with-modules \
		--with-readline="${EPREFIX}"/usr \
		--without-included-regex
}

src_install() {
	# FIXME: MKDIR_P is not getting picked up in po/Makefile
	emake DESTDIR="${D}" mkdir_p="mkdir -p" install

	local script
	for script in {convert-mozilla-cookies,verify-file}; do
		use ${script} || { rm "${ED}"/usr/share/${PN}/${script} || die ;}
	done
}

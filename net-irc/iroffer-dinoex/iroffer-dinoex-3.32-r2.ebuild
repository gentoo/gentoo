# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="de en fr it"
PLOCALE_BACKUP="en"

inherit plocale toolchain-funcs

DESCRIPTION="IRC fileserver using DCC"
HOMEPAGE="https://iroffer.net/"
SRC_URI="https://iroffer.net/${P}.tar.gz
	https://iroffer.net/HISTORY/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+admin +blowfish +chroot curl debug geoip gnutls +http +memsave ruby ssl +telnet upnp"

REQUIRED_USE="
	admin? ( http )
	gnutls? ( ssl )
"

RDEPEND="virtual/libcrypt:=
	acct-user/iroffer
	chroot? ( dev-libs/nss )
	curl? (
		net-misc/curl[ssl?]
		gnutls? ( net-misc/curl[curl_ssl_gnutls] )
		!gnutls? ( ssl? ( net-misc/curl[curl_ssl_openssl] ) )
	)
	geoip? ( dev-libs/geoip )
	gnutls? ( net-libs/gnutls )
	ruby? ( dev-lang/ruby:* )
	ssl? ( !gnutls? ( dev-libs/openssl:0= ) )"

DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}/${PN}-3.31-config.patch"
	eapply "${FILESDIR}/${PN}-Werror.patch"

	eapply_user

	plocale_find_changes "" 'help-admin-' '.txt'
}

do_configure() {
	echo ./Configure $*
	./Configure $* || die "configure phase failed"
}

src_configure() {
	do_configure \
		PREFIX="${EPREFIX}/usr" \
		CC="$(tc-getCC)" \
		$(usex debug '-profiling' '' '' '')\
		$(usex debug '-debug' '' '' '')\
		$(usex geoip '-geoip' '' '' '')\
		$(usex chroot '' '-no-chroot' '' '')\
		$(usex curl '-curl' '' '' '' )\
		$(usex gnutls  '-tls' '' '' '' '')\
		$(usex upnp '-upnp' '' '' '')\
		$(usex ruby '-ruby' '' '' '')\
		$(usex blowfish '' '-no-blowfish' '' '')\
		$(usex ssl '' '-no-openssl' '' '')\
		$(usex http '' '-no-http' '' '')\
		$(usex admin '' '-no-admin' '' '')\
		$(usex telnet '' '-no-telnet' '' '')\
		$(usex memsave '' '-no-memsave' '' '')
}

src_compile() {
	# TODO: default compile targets always include chrooted target, which is not good
	emake CC="$(tc-getCC)" $(plocale_get_locales)
}

myloc() {
	emake DESTDIR="${D}" install-${1}

	dodoc help-admin-${1}.txt
	use http && dodoc doc/INSTALL-linux-${1}.html

	insinto /etc/${PN}
	case ${1} in
	"de")
		doins beispiel.config;;
	"fr")
		doins exemple.config;;
	*)
		doins sample.config;;
	esac
}

src_install() {
	plocale_for_each_locale myloc

	dodoc README* THANKS TODO
	doman iroffer.1 xdcc.7

	newinitd "${FILESDIR}/${PN}.init" ${PN}
	newconfd "${FILESDIR}/${PN}.conf" ${PN}

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotate" ${PN}

	if use ruby; then
		insinto /usr/share/${PN}
		doins ruby-sample.rb
	fi

	if use http; then
		insinto /usr/share/${PN}/htdocs
		doins htdocs/*
	fi
}

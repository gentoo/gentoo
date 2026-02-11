# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="IRC fileserver using DCC"
HOMEPAGE="https://iroffer.net/"
SRC_URI="https://iroffer.net/${P}.tar.gz"

LICENSE="GPL-2+-with-openssl-exception MIT blowfish? ( LGPL-2.1+ ) upnp? ( BSD )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
MY_L10N=( de en fr it tr )
IUSE="+admin +blowfish curl debug geoip gnutls +http +memsave ruby ssl +telnet upnp"
IUSE+=" ${MY_L10N[@]/#/l10n_}"

REQUIRED_USE="admin? ( http )"

RUBY_DEP="dev-lang/ruby"
RDEPEND="
	acct-user/iroffer
	virtual/libcrypt:=
	curl? (
		net-misc/curl[ssl?]
		ssl? (
			gnutls? ( net-misc/curl[curl_ssl_gnutls] )
			!gnutls? ( net-misc/curl[curl_ssl_openssl] )
		)
	)
	geoip? ( dev-libs/libmaxminddb:= )
	ruby? ( ${RUBY_DEP}:* )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:0= )
	)
	upnp? ( net-libs/miniupnpc:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	l10n_de? ( ${RUBY_DEP} )
	l10n_fr? ( ${RUBY_DEP} )
	l10n_it? ( ${RUBY_DEP} )
	l10n_tr? ( ${RUBY_DEP} )
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.31-config.patch
	"${FILESDIR}"/${PN}-3.34-rm_Werror.patch
)

src_configure() {
	local lang
	for lang in "${MY_L10N[@]}"; do
		use "l10n_${lang}" && LANGS+=( "${lang}" )
	done
	: ${LANGS:=en}

	myconfargs=(
		PREFIX="${EPREFIX}/usr"
		CC="$(tc-getCC)"
		-no-chroot
		$(usev !admin -no-admin)
		$(usev !blowfish -no-blowfish)
		$(usev curl -curl)
		$(usev debug -debug)
		$(use !elibc_musl && usev debug -profiling)
		$(usev geoip -geoip)
		$(usev !http -no-http)
		$(usev !memsave -no-memsave)
		$(usev ruby -ruby)
		$(usex ssl "$(usex gnutls -tls '')" -no-openssl)
		$(usev !telnet -no-telnet)
		$(usev upnp -upnp)
	)
	edo ./Configure "${myconfargs[@]}"
}

src_compile() {
	emake "${LANGS[@]}"
}

myloc() {
	emake DESTDIR="${D}" install-${1}

	DOCS+=( help-admin-${1}.txt )
	use http && HTML_DOCS+=( doc/INSTALL-linux-${1}.html )

	insinto /etc/${PN}
	case ${1} in
	"de")
		DOCS+=( LIESMICH.modDinoex )
		doins beispiel.config;;
	"fr")
		doins exemple.config;;
	"tr")
		doins misal.config;;
	esac
}

src_install() {
	local DOCS=( README{,.modDinoex} TODO THANKS )

	local loc
	for loc in "${LANGS[@]}";
		do myloc "${loc}"
	done

	einstalldocs

	doman iroffer.1 xdcc.7

	insinto /etc/${PN}
	doins sample.config

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

pkg_postinst() {
	if ! use l10n_en; then
		ewarn "Please check BIN defined into "${EROOT}"/etc/conf.d/iroffer-dinoex"
		ewarn "The path must be made consistent with the desired language."
	fi
}

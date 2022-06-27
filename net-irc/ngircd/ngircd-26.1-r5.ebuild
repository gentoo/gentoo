# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/alexbarton.asc
inherit tmpfiles systemd verify-sig

DESCRIPTION="An IRC server written from scratch"
HOMEPAGE="https://ngircd.barton.de/"
SRC_URI="https://arthur.barton.de/pub/${PN}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( https://arthur.barton.de/pub/${PN}/${P}.tar.xz.sig )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~x64-macos"
IUSE="debug gnutls ident irc-plus +ipv6 pam +ssl strict-rfc tcpd test zlib"

# Flaky test needs investigation (bug #719256)
RESTRICT="test"

RDEPEND="
	acct-user/ngircd
	irc-plus? ( virtual/libiconv )
	ident? ( net-libs/libident )
	pam? ( sys-libs/pam )
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? (
			dev-libs/openssl:0=
		)
	)
	tcpd? ( sys-apps/tcp-wrappers )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-tcltk/expect
		net-misc/netkit-telnetd
	)
	verify-sig? ( sec-keys/openpgp-keys-alexbarton )
"

PATCHES=(
	"${FILESDIR}"/${PN}-26.1-systemd-unit.patch
)

src_prepare() {
	default

	if ! use prefix ; then
		sed -i \
			-e "/;ServerUID = /s/65534/ngircd/" \
			-e "/;ServerGID = /s/65534/ngircd/" \
			doc/sample-ngircd.conf.tmpl || die
	fi

	# Make pidfiles work out-of-the-box
	sed -i \
		-e "/;PidFile = /s/;//" \
		-e "/;ServerUID = /s/;//" \
		-e "/;ServerGID = /s/;//" \
		doc/sample-ngircd.conf.tmpl || die

	# Note that if we need to use automake, we need a certain version (for now):
	# https://github.com/ngircd/ngircd/issues/261
	# WANT_AUTOMAKE=1.11
	# eautomake
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/${PN}

		$(use_enable debug sniffer)
		$(use_enable debug)
		$(use_enable irc-plus ircplus)
		$(use_enable ipv6)
		$(use_enable strict-rfc)
		$(use_with irc-plus iconv)
		$(use_with ident)
		$(use_with pam)
		$(use_with tcpd tcp-wrappers)
		$(use_with zlib)
	)

	if use ssl ; then
		if use gnutls ; then
			myeconfargs+=(
				$( use_with gnutls )
			)
		else
			myeconfargs+=(
				$( use_with !gnutls openssl )
			)
		fi
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	fowners ngircd:ngircd /etc/ngircd/ngircd.conf

	newinitd "${FILESDIR}"/ngircd.init-r2.d ngircd
	newconfd "${FILESDIR}"/ngircd.conf.d ngircd

	systemd_dounit contrib/ngircd.{service,socket}

	dotmpfiles "${FILESDIR}"/ngircd.conf
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && use pam ; then
		elog "ngircd will use PAMIsOptionalPAM by default, please change this option."
		elog "You may not be able to login until you change this."
	fi

	tmpfiles_process ngircd.conf
}

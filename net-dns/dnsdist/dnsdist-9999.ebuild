# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/PowerDNS/pdns.git"

if [[ ${PV} = 9999 ]]; then
	ADDITIONAL_ECLASSES="autotools git-r3"
fi

inherit eutils flag-o-matic user ${ADDITIONAL_ECLASSES}

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="https://dnsdist.org"

if [[ ${PV} == 9999 ]]; then
	SRC_URI=""
	S="${WORKDIR}/${P}/pdns/dnsdistdist"
else
	SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="dnscrypt gnutls fstrm luajit regex remote-logging snmp +ssl systemd test"
RESTRICT="!test? ( test )"
REQUIRED_USE="dnscrypt? ( ssl )
		gnutls? ( ssl )"

RDEPEND="
	>=dev-libs/boost-1.35:=
	dev-libs/libedit:=
	fstrm? ( dev-libs/fstrm:= )
	luajit? ( dev-lang/luajit:= )
	!luajit? ( >=dev-lang/lua-5.1:= )
	remote-logging? ( >=dev-libs/protobuf-3:= )
	regex? ( dev-libs/re2:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? (
		dev-libs/libsodium:=
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
	systemd? ( sys-apps/systemd:0= )
"

DEPEND="${RDEPEND}
	virtual/pkgconfig
"

[[ ${PV} == 9999 ]] && DEPEND+="
	app-text/pandoc
	dev-util/ragel
	dev-python/virtualenv
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/dnsdist \
		$(use_enable dnscrypt) \
		$(use_enable fstrm) \
		$(use luajit && echo "--with-lua=luajit" || echo "--with-lua=lua" ) \
		$(use_enable regex re2) \
		$(use_with remote-logging protobuf) \
		$(use_with snmp net-snmp) \
		$(use_enable ssl libsodium) \
		$(use ssl && { echo "--enable-dns-over-tls" && use_enable gnutls && use_enable !gnutls libssl;} || echo "--disable-gnutls --disable-libssl") \
		$(use_enable systemd) \
		$(use_enable test unit-tests)
		if [ ${PV} == "1.3.3" ]; then
			sed 's/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl$libdir'\''/hardcode_libdir_flag_spec_CXX='\''$wl-rpath $wl\/$libdir'\''/g' \
			-i "${S}/configure"
		fi
}

src_install() {
	default

	insinto /etc/dnsdist
	doins "${FILESDIR}"/dnsdist.conf.example

	newconfd "${FILESDIR}"/dnsdist.confd ${PN}
	newinitd "${FILESDIR}"/dnsdist.initd ${PN}
}

pkg_preinst() {
	enewgroup dnsdist
	enewuser dnsdist -1 -1 -1 dnsdist
}

pkg_postinst() {
	elog "dnsdist provides multiple instances support. You can create more instances"
	elog "by symlinking the dnsdist init script to another name."
	elog
	elog "The name must be in the format dnsdist.<suffix> and dnsdist will use the"
	elog "/etc/dnsdist/dnsdist-<suffix>.conf configuration file instead of the default."
}

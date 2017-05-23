# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/PowerDNS/pdns.git"

if [[ ${PV} = 9999 ]]; then
	ADDITIONAL_ECLASSES="autotools git-r3"
fi

inherit eutils flag-o-matic user ${ADDITIONAL_ECLASSES}

DESCRIPTION="A highly DNS-, DoS- and abuse-aware loadbalancer"
HOMEPAGE="http://dnsdist.org"

if [[ ${PV} == 9999 ]]; then
	SRC_URI=""
	S="${WORKDIR}/${P}/pdns/dnsdistdist"
else
	SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="dnscrypt luajit readline regex remote-logging snmp +ssl test"
RESTRICT="readline? ( bindist )"
REQUIRED_USE="dnscrypt? ( ssl )"

DEPEND="
	>=dev-libs/boost-1.35:=
	luajit? ( dev-lang/luajit:= )
	!luajit? ( >=dev-lang/lua-5.1:= )
	remote-logging? ( dev-libs/protobuf:= )
	readline? ( sys-libs/readline:0= )
	!readline? ( dev-libs/libedit:= )
	regex? ( dev-libs/re2:= )
	snmp? ( net-analyzer/net-snmp:= )
	ssl? ( dev-libs/libsodium:= )
"

RDEPEND="${DEPEND}"

[[ ${PV} == 9999 ]] && DEPEND+="
	app-text/pandoc
	dev-util/ragel
"

src_prepare() {
	eapply "${FILESDIR}/${PN}-readline.patch"
	eapply_user

	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	if use readline ; then
		local -x LIBEDIT_CFLAGS="-I/usr/include/readline"
		local -x LIBEDIT_LIBS="-lreadline -lcurses"
		append-cxxflags -DREADLINE
	fi

	econf \
		--sysconfdir=/etc/dnsdist \
		$(use_enable ssl libsodium) \
		$(use_with remote-logging protobuf) \
		$(use_enable regex re2) \
		$(use_enable dnscrypt) \
		$(use_with luajit) \
		$(use_enable test unit-tests) \
		$(use_with snmp net-snmp)
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

	if use readline ; then
		ewarn "dnsdist (GPLv2) was linked against readline (GPLv3)."
		ewarn "A binary distribution should therefore not happen."
	fi
}

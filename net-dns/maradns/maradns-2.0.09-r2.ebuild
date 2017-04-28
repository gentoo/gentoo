# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd toolchain-funcs user

DEADWOOD_VER="3.2.05"

DESCRIPTION="A security-aware DNS server"
HOMEPAGE="http://www.maradns.org/"
SRC_URI="http://www.maradns.org/download/${PV%.*}/${PV}/${P}.tar.bz2"

# The GPL-2 covers the init script, bug 426018.
LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE="authonly examples ipv6"

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-2.0.06-askmara-tcp.patch"
	"${FILESDIR}/${PN}-2.0.06-duende-man.patch"
	"${FILESDIR}/${P}-build.patch"
)

pkg_setup() {
	ebegin "Creating group and users"
	enewgroup maradns 99
	enewuser duende 66 -1 -1 maradns
	enewuser maradns 99 -1 -1 maradns
	eend ${?}
}

src_configure() {
	# Use duende-ng.c.
	cp  "${S}/tools/duende-ng.c" "${S}/tools/duende.c" \
		|| die "failed to rename duende-ng.c"

	tc-export CC
	./configure $(use ipv6 && echo "--ipv6") || die "Failed to configure ${PN}"
}

src_install() {
	# Install the MaraDNS binaries.
	dosbin server/maradns
	dosbin tcp/zoneserver
	dobin tcp/getzone tcp/fetchzone
	dobin tools/askmara tools/askmara-tcp tools/duende
	dobin tools/bind2csv2.py tools/csv1tocsv2.pl

	# MaraDNS docs, manpages, misc.
	dodoc doc/en/{QuickStart,README,*.txt}
	dodoc doc/en/text/*.txt
	doman doc/en/man/*.[1-9]
	dodoc maradns.gpg.key
	dodoc doc/en/*.html
	dodoc -r doc/en/webpage
	dodoc -r doc/en/tutorial
	if use examples ; then
		docinto examples
		dodoc doc/en/examples/example_*
	fi

	# Deadwood binary, docs, manpages, etc.
	if ! use authonly; then
		dosbin deadwood-${DEADWOOD_VER}/src/Deadwood
		doman deadwood-${DEADWOOD_VER}/doc/{Deadwood,Duende}.1
		docinto deadwood
		dodoc deadwood-${DEADWOOD_VER}/doc/{Deadwood,Duende,FAQ}.txt
		dodoc deadwood-${DEADWOOD_VER}/doc/{Deadwood,FAQ}.html
		docinto deadwood/internals
		dodoc deadwood-${DEADWOOD_VER}/doc/internals/*
		insinto /etc/maradns
		newins deadwood-${DEADWOOD_VER}/doc/dwood3rc-all dwood3rc_all.dist
	fi

	# Example configurations.
	insinto /etc/maradns
	newins doc/en/examples/example_full_mararc mararc_full.dist
	newins doc/en/examples/example_csv2 example_csv2.dist
	keepdir /etc/maradns/logger

	# Init scripts.
	newinitd "${FILESDIR}"/maradns2 maradns
	newinitd "${FILESDIR}"/zoneserver2 zoneserver
	if ! use authonly; then
		newinitd "${FILESDIR}"/deadwood deadwood
	fi

	# systemd unit
	# please keep paths in sync!
	sed -e "s^@bindir@^${EPREFIX}/usr/sbin^" \
		-e "s^@sysconfdir@^${EPREFIX}/etc/maradns^" \
		"${FILESDIR}"/maradns.service.in > "${T}"/maradns.service \
		|| die "failed to create the maradns.service file (sed)"

	systemd_dounit "${T}"/maradns.service
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module toolchain-funcs

DESCRIPTION="Port Scanning Attack Detection daemon"
HOMEPAGE="https://www.cipherdyne.org/psad/"
SRC_URI="https://www.cipherdyne.org/psad/download/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ppc ~sparc x86"

RDEPEND="
	dev-perl/Bit-Vector
	dev-perl/Date-Calc
	dev-perl/NetAddr-IP
	dev-perl/Unix-Syslog
	net-firewall/iptables
	net-misc/whois
	virtual/logger
	virtual/mailx
	virtual/perl-Storable"
BDEPEND="virtual/perl-ExtUtils-MakeMaker"

PATCHES=( "${FILESDIR}"/${PN}-2.2.4-var-run.patch )

src_prepare() {
	default

	sed -i \
		-e 's|/usr/bin/gcc|$(CC)|g' \
		-e 's|-O|$(CFLAGS) $(LDFLAGS)|g' \
		Makefile || die
	# Fix up default paths
	sed -i \
		-e "s:/usr/bin/whois_psad:/usr/bin/whois:g" \
		psad.conf || die
}

src_configure() {
	default

	local d
	for d in IPTables-Parse IPTables-ChainMgr; do
		cd "${S}"/deps/${d} || die
		perl-module_src_configure
	done
}

src_compile() {
	tc-export CC
	default

	local d
	for d in IPTables-Parse IPTables-ChainMgr; do
		cd "${S}"/deps/${d} || die
		perl-module_src_compile
	done
}

src_install() {
	newbin misc/pscan psad-pscan

	dosbin kmsgsd psad psadwatchd
	newsbin fwcheck_psad.pl fwcheck_psad

	insinto /etc/psad
	doins \
		*.conf auto_dl icmp{,6}_types ip_options psad_* pf.os posf \
		protocols signatures

	newinitd init-scripts/psad-init.gentoo psad

	doman doc/*.8

	dodoc doc/BENCHMARK CREDITS Change* doc/FW_EXAMPLE_RULES README \
		doc/README.SYSLOG doc/SCAN_LOG

	insinto /etc/psad/snort_rules
	doins deps/snort_rules/*

	local d
	for d in IPTables-Parse IPTables-ChainMgr; do
		cd "${S}"/deps/${d} || die
		perl-module_src_install
	done
}

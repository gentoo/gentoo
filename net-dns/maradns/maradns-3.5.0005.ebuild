# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit systemd toolchain-funcs python-any-r1

DESCRIPTION="A security-aware DNS server"
HOMEPAGE="http://www.maradns.org/"
SRC_URI="https://maradns.samiam.org/download/${PV%.*}/${PV}/${P}.tar.xz"

# The GPL-2 covers the init script, bug 426018.
LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~x86"
IUSE="examples ipv6"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	acct-user/maradns
	acct-group/maradns
	acct-user/duende
	dev-lang/perl"

src_prepare() {
	default

	# replace "make" by "$(MAKE)" to avoid GNU Make warning
	sed -i 's/\ make\ /\ \$\(MAKE\)\ /g' build/Makefile.linux \
		|| die "can't patch build/Makefile.linux"

	python_fix_shebang tools/bind2csv2.py
}

src_configure() {
	tc-export CC
	./configure $(use ipv6 && echo "--ipv6") || die "Failed to configure ${PN}"
}

src_install() {
	# Install the MaraDNS and Deadwood binaries
	dosbin server/maradns
	dosbin tcp/zoneserver
	dosbin deadwood-${PV}/src/Deadwood
	dobin tcp/{getzone,fetchzone}
	dobin tools/{askmara,askmara-tcp,duende,bind2csv2.py,csv1tocsv2.pl}

	# MaraDNS docs, manpages, misc
	dodoc doc/en/{QuickStart,README,*.txt,*.html}
	dodoc -r doc/en/{text,webpage,tutorial}
	dodoc maradns.gpg.key
	docinto deadwood
	dodoc deadwood-${PV}/doc/{*.txt,*.html,CHANGELOG,Deadwood-HOWTO}
	dodoc -r deadwood-${PV}/doc/internals

	# Install examples (optional)
	if use examples ; then
		docinto examples
		dodoc doc/en/examples/example_*
	fi

	# Install manpages
	doman doc/en/man/*.[1-9]
	doman deadwood-${PV}/doc/{Deadwood,Duende}.1

	# Example configurations.
	insinto /etc/maradns
	newins doc/en/examples/example_full_mararc mararc_full.dist
	newins doc/en/examples/example_csv2 example_csv2.dist
	newins deadwood-${PV}/doc/dwood3rc-all dwood3rc_all.dist
	keepdir /etc/maradns/logger

	# Init scripts.
	newinitd "${FILESDIR}"/maradns2 maradns
	newinitd "${FILESDIR}"/zoneserver2 zoneserver
	newinitd "${FILESDIR}"/deadwood deadwood

	# systemd unit
	# please keep paths in sync!
	sed -e "s^@bindir@^${EPREFIX}/usr/sbin^" \
		-e "s^@sysconfdir@^${EPREFIX}/etc/maradns^" \
		"${FILESDIR}"/maradns.service.in > "${T}"/maradns.service \
		|| die "failed to create the maradns.service file (sed)"

	systemd_dounit "${T}"/maradns.service
}

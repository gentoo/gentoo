# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 systemd toolchain-funcs user

DEADWOOD_VER="3.2.12"

DESCRIPTION="A security-aware DNS server"
HOMEPAGE="http://www.maradns.org/"
SRC_URI="http://www.maradns.org/download/${PV%.*}/${PV}/${P}.tar.bz2"

# The GPL-2 covers the init script, bug 426018.
LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE="authonly examples ipv6"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-lang/perl"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default

	# Use duende-ng.c.
	cp tools/duende{,-ng}.c \
		|| die "failed to rename duende-ng.c"
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
	if ! use authonly; then
		dosbin deadwood-${DEADWOOD_VER}/src/Deadwood
	fi
	dobin tcp/{getzone,fetchzone}
	dobin tools/{askmara,askmara-tcp,duende,bind2csv2.py,csv1tocsv2.pl}

	# MaraDNS docs, manpages, misc
	dodoc doc/en/{QuickStart,README,*.txt,*.html}
	dodoc -r doc/en/{text,webpage,tutorial}
	dodoc maradns.gpg.key
	if ! use authonly; then
		docinto deadwood
		dodoc deadwood-${DEADWOOD_VER}/doc/{*.txt,*.html,CHANGELOG,Deadwood-HOWTO}
		dodoc -r deadwood-${DEADWOOD_VER}/doc/internals
	fi

	# Install examples (optional)
	if use examples ; then
		docinto examples
		dodoc doc/en/examples/example_*
	fi

	# Install manpages
	doman doc/en/man/*.[1-9]
	if ! use authonly; then
		doman deadwood-${DEADWOOD_VER}/doc/{Deadwood,Duende}.1
	fi

	# Example configurations.
	insinto /etc/maradns
	newins doc/en/examples/example_full_mararc mararc_full.dist
	newins doc/en/examples/example_csv2 example_csv2.dist
	if ! use authonly; then
		newins deadwood-${DEADWOOD_VER}/doc/dwood3rc-all dwood3rc_all.dist
	fi
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

pkg_preinst() {
	enewgroup maradns 99
	enewuser duende 66 -1 -1 maradns
	enewuser maradns 99 -1 -1 maradns
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
inherit flag-o-matic python-any-r1 systemd toolchain-funcs

DESCRIPTION="A security-aware DNS server"
HOMEPAGE="https://maradns.samiam.org"
SRC_URI="https://maradns.samiam.org/download/${PV%.*}/${PV}/${P}.tar.xz"

# The GPL-2 covers the init script, bug 426018.
LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc x86"
IUSE="examples"

BDEPEND="${PYTHON_DEPS}
	dev-lang/perl"
RDEPEND="
	acct-group/maradns
	acct-user/duende
	acct-user/maradns"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
)

src_prepare() {
	default
	python_fix_shebang tools/bind2csv2.py
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/861293
	# https://github.com/samboy/MaraDNS/discussions/124
	filter-lto

	tc-export CC
	./configure --ipv6 || die "Failed to configure"
}

src_install() {
	# Install the MaraDNS and Deadwood binaries
	dosbin server/maradns
	dosbin tcp/zoneserver
	dosbin deadwood-${PV}/src/Deadwood
	dobin tcp/{getzone,fetchzone}
	dobin tools/{askmara,askmara-tcp,duende,bind2csv2.py,csv1tocsv2.pl}

	# MaraDNS docs, manpages, misc
	docompress -x /usr/share/doc/${PF}/maradns.gpg.key
	dodoc {CHANGELOG.TXT,COPYING,SUPPORT,maradns.gpg.key}
	dodoc doc/en/{QuickStart,faq.*,*.md,README}
	dodoc -r doc/en/{text,webpage,tutorial}
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

pkg_postinst() {
	elog "Examples of configuration files can be found in the"
	elog "/etc/maradns directory, feel free use it like:"
	elog "     cp /etc/maradns/mararc{_full.dist,}"
	elog "and edit /etc/maradns/mararc as described in man mararc."
}

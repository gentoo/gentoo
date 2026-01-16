# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit flag-o-matic readme.gentoo-r1 toolchain-funcs

DESCRIPTION="Collection of DNS client/server software"
HOMEPAGE="https://cr.yp.to/djbdns.html"
IPV6_PATCH="test32"
GENTOO_PATCH="1"

SRC_URI="https://cr.yp.to/djbdns/${P}.tar.gz
	https://smarden.org/pape/djb/manpages/${P}-man.tar.gz
	https://downloads.uls.co.za/gentoo/djbdns/djbdns-gentoo-${GENTOO_PATCH}.tar.bz2
	ipv6? ( https://www.fefe.de/dns/${P}-${IPV6_PATCH}.diff.xz )"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 selinux"

RDEPEND="
	acct-user/dnscache
	acct-user/dnslog
	acct-user/tinydns
	sys-apps/ucspi-tcp
	virtual/daemontools
	selinux? ( sec-policy/selinux-djbdns )"

src_unpack() {
	# Unpack both djbdns and its man pages to separate directories.
	default

	# Now move the man pages under ${S} so that user patches can be
	# applied to them as well in src_prepare().
	mv "${PN}-man" "${P}/man" || die "failed to transplant man pages"
}

PATCHES=(
	"${WORKDIR}/djbdns-gentoo-${GENTOO_PATCH}/base"
)

src_prepare() {
	if use ipv6; then
		PATCHES+=(
			# The big ipv6 patch.
			"${WORKDIR}/${P}-${IPV6_PATCH}.diff"
			"${WORKDIR}/djbdns-gentoo-${GENTOO_PATCH}/ipv6"
		)
	else
		PATCHES+=(
			"${WORKDIR}/djbdns-gentoo-${GENTOO_PATCH}/nov6"
		)
	fi

	default

	# Change "head -X" to the posix-compatible "head -nX" within the
	# Makefile. We do this with sed instead of a patch because the ipv6
	# patch uses some of the surrounding lines; we'd need two versions
	# of the patch.
	sed -i Makefile \
		-e 's/head[[:space:]]\{1,\}\-\([0-9]\{1,\}\)/head -n\1/g' \
		|| die 'failed to sed head in the Makefile'
}

src_compile() {
	# djb is a skeptic when it comes to optimizing compilers. He doesn't like
	# them "ruining" his code, thinks only algorithms matter for performance,
	# and writes code that triggers UB warnings. Respect his point of view.
	if is-flagq -O?; then
		CFLAGS="-O2"
	else
		CFLAGS=""
	fi
	append-flags -fno-strict-aliasing

	# Bug 927539. This is beyond our ability to realistically fix due
	# to patch conflicts.
	append-cflags $(test-flags-CC -Wno-error=incompatible-pointer-types)

	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "/usr" > conf-home || die
	emake AR=$(tc-getAR) RANLIB=$(tc-getRANLIB)
}

src_install() {
	insinto /etc
	doins dnsroots.global

	into /usr
	dobin *-conf dnscache tinydns walldns rbldns pickdns axfrdns \
		*-get *-data *-edit dnsip dnsipq dnsname dnstxt dnsmx \
		dnsfilter random-ip dnsqr dnsq dnstrace dnstracesort

	if use ipv6; then
		dobin dnsip6 dnsip6q
	fi

	dodoc CHANGES README

	doman man/*.[158]

	readme.gentoo_create_doc
}

DISABLE_AUTOFORMATTING=1
DOC_CONTENTS='
To configure djbdns, please follow the instructions at,

	http://cr.yp.to/djbdns.html

Of particular interest are,

	axfrdns : http://cr.yp.to/djbdns/axfrdns-conf.html
	dnscache: http://cr.yp.to/djbdns/run-cache-x-home.html
	tinydns : http://cr.yp.to/djbdns/run-server.html

Portage has created users for axfrdns, dnscache, and tinydns; the
commands to configure these programs are,

	1. axfrdns-conf tinydns dnslog /var/axfrdns /var/tinydns $ip
	2. dnscache-conf dnscache dnslog /var/dnscache $ip
	3. tinydns-conf tinydns dnslog /var/tinydns $ip

(replace $ip with the ip address on which the server will run).

If you wish to configure rbldns or walldns, you will need to create
those users yourself (although you should still use the "dnslog"
user for the logs):

	4. rbldns-conf $username dnslog /var/rbldns $ip $base
	5. walldns-conf $username dnslog /var/walldns $ip
'

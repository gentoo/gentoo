# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic readme.gentoo toolchain-funcs user

DESCRIPTION="Collection of DNS client/server software"
HOMEPAGE="http://cr.yp.to/djbdns.html"
IPV6_PATCH="test27"

SRC_URI="http://cr.yp.to/djbdns/${P}.tar.gz
	http://smarden.org/pape/djb/manpages/${P}-man.tar.gz
	ipv6? ( http://www.fefe.de/dns/${P}-${IPV6_PATCH}.diff.bz2 )"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="ipv6 selinux"

DEPEND=""
RDEPEND="sys-apps/ucspi-tcp
	virtual/daemontools
	selinux? ( sec-policy/selinux-djbdns )"

src_unpack(){
	# Unpack both djbdns and its man pages to separate directories.
	default

	# Now move the man pages under ${S} so that user patches can be
	# applied to them as well in src_prepare().
	mv "${PN}-man" "${P}/man" || die "failed to transplant man pages"
}

src_prepare() {
	epatch \
		"${FILESDIR}/headtail.patch" \
		"${FILESDIR}/dnsroots.patch" \
		"${FILESDIR}/dnstracesort.patch" \
		"${FILESDIR}/string_length_255.patch" \
		"${FILESDIR}/srv_record_support.patch"

	# Fix CVE2009-0858
	epatch "${FILESDIR}/CVE2009-0858_0001-check-response-domain-name-length.patch"

	if use ipv6; then
		elog 'At present dnstrace does NOT support IPv6. It will'\
			 'be compiled without IPv6 support.'

		# Create a separate copy of the source tree for dnstrace.
		cp -pR "${S}" "${S}-noipv6" || die

		# The big ipv6 patch.
		epatch "${WORKDIR}/${P}-${IPV6_PATCH}.diff"

		# Fix CVE2008-4392 (ipv6)
		epatch \
			"${FILESDIR}/CVE2008-4392_0001-dnscache-merge-similar-outgoing-queries-ipv6-test25.patch" \
			"${FILESDIR}/CVE2008-4392_0002-dnscache-cache-soa-records-ipv6.patch" \
			"${FILESDIR}/makefile-parallel-test25.patch"

		cd "${S}-noipv6" || die
	fi

	# Fix CVE2008-4392 (no ipv6)
	epatch \
		"${FILESDIR}/CVE2008-4392_0001-dnscache-merge-similar-outgoing-queries.patch" \
		"${FILESDIR}/CVE2008-4392_0002-dnscache-cache-soa-records.patch"

	# Later versions of the ipv6 patch include this, but even if
	# USE=ipv6, we're in the ${S}-noipv6 directory at this point.
	epatch "${FILESDIR}/${PV}-errno.patch"

	epatch_user
}

src_compile() {
	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "/usr" > conf-home || die
	emake

	# If djbdns is compiled with IPv6 support, it breaks dnstrace.
	# Therefore we must compile dnstrace separately without IPv6
	# support.
	if use ipv6; then
		elog 'Compiling dnstrace without ipv6 support'
		cp conf-cc conf-ld conf-home "${S}-noipv6/" || die
		cd "${S}-noipv6" || die
		emake dnstrace
	fi
}

src_install() {
	insinto /etc
	doins dnsroots.global

	into /usr
	dobin *-conf dnscache tinydns walldns rbldns pickdns axfrdns \
		*-get *-data *-edit dnsip dnsipq dnsname dnstxt dnsmx \
		dnsfilter random-ip dnsqr dnsq dnstrace dnstracesort

	if use ipv6; then
		dobin dnsip6 dnsip6q "${S}-noipv6/dnstrace"
	fi

	dodoc CHANGES README

	doman man/*.[158]

	readme.gentoo_create_doc
}

pkg_preinst() {
	# The nofiles group is no longer provided by baselayout.
	# Share it with qmail if possible.
	enewgroup nofiles 200

	enewuser dnscache -1 -1 -1 nofiles
	enewuser dnslog -1 -1 -1 nofiles
	enewuser tinydns -1 -1 -1 nofiles
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

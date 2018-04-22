# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

# Force users doing their own patches to install their own tools
AUTOTOOLS_AUTO_DEPEND=no

inherit eutils multilib systemd toolchain-funcs autotools

DESCRIPTION="Linux kernel (2.4+) firewall, NAT and packet mangling tools"
HOMEPAGE="https://www.netfilter.org/projects/iptables/"
SRC_URI="https://www.netfilter.org/projects/iptables/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="conntrack ipv6 netlink static-libs"

RDEPEND="
	conntrack? ( net-libs/libnetfilter_conntrack )
	netlink? ( net-libs/libnfnetlink )
"
DEPEND="${RDEPEND}
	virtual/os-headers
	virtual/pkgconfig
"

src_prepare() {
	# use the saner headers from the kernel
	rm -f include/linux/{kernel,types}.h

	# Only run autotools if user patched something
	epatch_user && eautoreconf || elibtoolize
}

src_configure() {
	# Some libs use $(AR) rather than libtool to build #444282
	tc-export AR

	sed -i \
		-e "/nfnetlink=[01]/s:=[01]:=$(usex netlink 1 0):" \
		-e "/nfconntrack=[01]/s:=[01]:=$(usex conntrack 1 0):" \
		configure || die

	econf \
		--sbindir="${EPREFIX}/sbin" \
		--libexecdir="${EPREFIX}/$(get_libdir)" \
		--enable-devel \
		--enable-shared \
		$(use_enable static-libs static) \
		$(use_enable ipv6)
}

src_compile() {
	emake V=1
}

src_install() {
	default
	dodoc INCOMPATIBILITIES iptables/iptables.xslt

	# all the iptables binaries are in /sbin, so might as well
	# put these small files in with them
	into /
	dosbin iptables/iptables-apply
	dosym iptables-apply /sbin/ip6tables-apply
	doman iptables/iptables-apply.8

	insinto /usr/include
	doins include/iptables.h $(use ipv6 && echo include/ip6tables.h)
	insinto /usr/include/iptables
	doins include/iptables/internal.h

	keepdir /var/lib/iptables
	newinitd "${FILESDIR}"/${PN}-1.4.13-r1.init iptables
	newconfd "${FILESDIR}"/${PN}-1.4.13.confd iptables
	if use ipv6 ; then
		keepdir /var/lib/ip6tables
		newinitd "${FILESDIR}"/iptables-1.4.13-r1.init ip6tables
		newconfd "${FILESDIR}"/ip6tables-1.4.13.confd ip6tables
	fi

	systemd_dounit "${FILESDIR}"/systemd/iptables{,-{re,}store}.service
	if use ipv6 ; then
		systemd_dounit "${FILESDIR}"/systemd/ip6tables{,-{re,}store}.service
	fi

	# Move important libs to /lib #332175
	gen_usr_ldscript -a ip{4,6}tc iptc xtables

	prune_libtool_files
}

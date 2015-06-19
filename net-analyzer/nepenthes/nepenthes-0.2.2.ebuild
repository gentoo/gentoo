# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nepenthes/nepenthes-0.2.2.ebuild,v 1.9 2012/10/02 13:26:00 pinkbyte Exp $

EAPI="2"
inherit autotools eutils user

DESCRIPTION="Nepenthes is a low interaction honeypot that captures worms by emulating known vulnerabilities"
HOMEPAGE="http://nepenthes.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://gentoo/${P}-gcc44.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
# selinux

DEPEND="net-misc/curl
	sys-apps/file
	dev-libs/libpcre
	net-libs/adns"

RDEPEND=""
#RDEPEND=" selinux? ( sec-policy/selinux-nepenthes )"

pkg_setup() {
	enewgroup nepenthes
	enewuser nepenthes -1 -1 /dev/null nepenthes
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${WORKDIR}"/${P}-gcc44.patch
	sed -i modules/shellcode-signatures/shellcode-signatures.cpp \
		-e 's|var/cache|/var/lib/cache|' || die
	sed -i configure.ac \
		-e 's|-R/usr/local/lib||g' || die
	find . -name Makefile.am -exec sed 's: -Werror::' -i '{}' \;

	# fix for bug #426482
	has_version ">=net-misc/curl-7.22.0" && find . -type f -exec sed '/#include <curl\/types.h>/d' -i '{}' \;

	eautoreconf
}

src_configure() {
	econf --sysconfdir=/etc \
		  --localstatedir=/var/lib/nepenthes \
		  --enable-capabilities
}

src_install() {
	einstall || die "make install failed"

	for i in "${D}"/etc/nepenthes/*; do
		sed -i \
			-e 's|"var/binaries|"/var/lib/nepenthes/binaries|' \
			-e 's|"var/hexdumps|"/var/lib/nepenthes/hexdumps|' \
			-e 's|"var/cache/nepenthes|"/var/lib/nepenthes/cache|' \
			-e 's|"var/log|"/var/log/nepenthes|' \
			-e 's|"lib/nepenthes|"/usr/lib/nepenthes|' \
			-e 's|"etc|"/etc|' $i
	done

	dodoc doc/README.VFS AUTHORS
	dosbin nepenthes-core/src/nepenthes || die "dosbin failed"
	rm "${D}"/usr/bin/nepenthes
	rm "${D}"/usr/share/doc/README.VFS
	rm "${D}"/usr/share/doc/logo-shaded.svg

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	diropts -m 755 -o nepenthes -g nepenthes
	keepdir /var/log/nepenthes
	keepdir /var/lib/nepenthes
	keepdir /var/lib/nepenthes/binaries
	keepdir /var/lib/nepenthes/hexdumps
	keepdir /var/lib/nepenthes/cache
	keepdir /var/lib/nepenthes/cache/geolocation
}

# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="DNS serial number incrementer and reverse zone builder"
SRC_URI="http://uranus.it.swin.edu.au/~jn/linux/${P}.tar.gz"
HOMEPAGE="http://uranus.it.swin.edu.au/~jn/linux/dns.htm"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND="sys-apps/sed"
RDEPEND="sys-apps/ed" # dnstouch calls ed to do the dirty work

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/${P}-binary-locations.patch

	cd "${S}"/src
	# use the correct compiler
	sed -e 's|gcc|$(CXX)|g' -i Makefile
	# set correct config pathes
	sed -e 's|#define CONFIG_PATH "/etc/"|#define CONFIG_PATH "/etc/bind/"|g' -i ndu.cpp
	sed -e 's|"/etc/ndu.conf"|"/etc/bind/ndu.conf"|g' -i dnstouch.cpp
	# hack up something to work around bug #73858
	sed -e 's|execlp("ed", "ed", filename, 0);|execlp("ed", "ed", "-s", filename, 0);|g' -i dnstouch.cpp
	# use the correct editor
	sed -e 's|VISUAL|EDITOR|g' -i dnsedit

	cd "${S}"
	# match our bind config
	sed -e 's|0.0.127.in-addr.arpa|127.in-addr.arpa|g' -i ndu.conf
	# document the support for the chrooted BIND setup
	echo '// if you use a chrooted setup, then you need to uncomment these lines:' >>ndu.conf
	echo '//process "/chroot/dns/named.conf"' >>ndu.conf
	echo '//chroot "/chroot/dns"' >>ndu.conf
}

src_compile() {
	cd "${S}"/src
	emake CFLAGS="${CFLAGS}" CXX="$(tc-getCXX)"
}

src_install () {
	into /usr
	dobin src/{dnsedit,ndu,dnstouch}
	into /
	insinto /etc/bind
	doins ndu.conf
	dodoc README INSTALL
}

pkg_postinst() {
	elog "The ndu binary expects to read your configuration"
	elog "from /etc/bind/named.conf, however the other binaries"
	elog "are useful with BIND locally installed."
}

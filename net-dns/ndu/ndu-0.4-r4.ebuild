# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="DNS serial number incrementer and reverse zone builder"
SRC_URI="http://uranus.it.swin.edu.au/~jn/linux/${P}.tar.gz"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="sys-apps/ed" # dnstouch calls ed to do the dirty work

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-binary-locations.patch

	# match our bind config
	sed -e 's|0.0.127.in-addr.arpa|127.in-addr.arpa|g' -i ndu.conf || die
	# document the support for the chrooted BIND setup
	cat >> ndu.conf <<-EOF || die
		// if you use a chrooted setup, then you need to uncomment these lines:
		//process "/chroot/dns/named.conf"
		//chroot "/chroot/dns"
	EOF

	cd src || die
	# use the correct compiler
	sed -e 's|gcc|$(CXX)|g' -i Makefile || die
	# set correct config pathes
	sed -e 's|#define CONFIG_PATH "/etc/"|#define CONFIG_PATH "/etc/bind/"|g' \
		-i ndu.cpp || die
	sed -e 's|"/etc/ndu.conf"|"/etc/bind/ndu.conf"|g' -i dnstouch.cpp || die
	# hack up something to work around bug #73858
	sed -e 's|execlp("ed", "ed", filename, 0);|execlp("ed", "ed", "-s", filename, 0);|g' \
		-i dnstouch.cpp || die
	# use the correct editor
	sed -e 's|VISUAL|EDITOR|g' -i dnsedit || die
}

src_compile() {
	emake -C src CFLAGS="${CFLAGS}" CXX="$(tc-getCXX)"
}

src_install () {
	dobin src/{dnsedit,ndu,dnstouch}
	insinto /etc/bind
	doins ndu.conf
	dodoc README INSTALL
}

pkg_postinst() {
	elog "The ndu binary expects to read your configuration"
	elog "from /etc/bind/named.conf, however the other binaries"
	elog "are useful with BIND locally installed."
}

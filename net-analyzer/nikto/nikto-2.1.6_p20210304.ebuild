# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Web server vulnerability scanner"
HOMEPAGE="https://www.cirt.net/Nikto2"
COMMIT="8a4b5fb86ae8a1b4f31c32da0bcedd3bcaf4deb8"
MY_P="${PN}-${COMMIT}"
SRC_URI="https://github.com/sullo/nikto/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"

# nikto provides its own libwhisker, do no use net-libs/libwhisker[ssl]
# https://bugs.gentoo.org/533900
RDEPEND="
	dev-lang/perl
	dev-perl/Net-SSLeay
	net-analyzer/nmap
	virtual/perl-JSON-PP
"

S="${WORKDIR}/${MY_P}/program"

src_prepare() {
	sed -i -e 's:/etc/nikto.conf:/etc/nikto/nikto.conf:' nikto.pl || die
	sed -i -e 's:# EXECDIR=/opt/nikto:EXECDIR=/usr/share/nikto:' nikto.conf.default || die

	default
}

src_install() {
	insinto /etc/nikto
	newins nikto.conf.default nikto.conf

	dobin nikto.pl replay.pl
	dosym nikto.pl /usr/bin/nikto

	insinto /usr/share/nikto
	doins -r plugins templates databases

	dodoc docs/*.txt
	dodoc docs/nikto_manual.html
}

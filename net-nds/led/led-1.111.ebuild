# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A general purpose LDAP editor"
HOMEPAGE="http://led.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1
	dev-perl/perl-ldap
	dev-perl/URI
	virtual/perl-Digest-MD5
	dev-perl/Authen-SASL"
DEPEND=${RDEPEND}

src_configure() {
	# non-standard configure system!
	perl Configure --prefix=/usr --generic --rfc2307 --shadow --iplanet || die
}

src_compile() {
	# parallel make bad
	emake -j1
}

src_install() {
	dobin ldapcat led
	dodoc INSTALL README README.ldapcat TODO
}

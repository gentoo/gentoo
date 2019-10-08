# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fixheadtails qmail

DESCRIPTION="Command-line tools for building SSL client-server applications"
HOMEPAGE="https://www.fehcom.de/ipnet/ucspi-ssl.html"
SRC_URI="https://www.fehcom.de/ipnet/ucspi-ssl/${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="bindist perl libressl"

DEPEND="<sys-libs/fehqlibs-13:=
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0=[bindist=] )
	perl? ( dev-lang/perl:= )"
RDEPEND="${DEPEND}
	sys-apps/ucspi-tcp"

S="${WORKDIR}"/host/superscript.com/net/${P}

src_prepare() {
	sed -i -e '1s:$: -I/usr/include/qlibs:' conf-cc || die

	echo "/usr" > conf-home || die
	echo "/usr/share/ca-certificates/" > conf-cadir || die
	echo "${QMAIL_HOME}/control/dh1024.pem" > conf-dhfile || die

	eapply_user
}

src_compile() {
	cd src || die
	emake -j1 sysdeps
	emake -j1

	sed -i -e '/Host:/s:\[\|\]::g' https@ || die
}

src_install() {
	dodoc -r doc/.
	doman man/*.[1-9]

	cd src || die
	dobin $(<../package/commands-base)
	use perl && dobin $(<../package/commands-sslperl)
}

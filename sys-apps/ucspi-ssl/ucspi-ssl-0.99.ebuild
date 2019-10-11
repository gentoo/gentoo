# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit fixheadtails qmail

DESCRIPTION="Command-line tools for building SSL client-server applications"
HOMEPAGE="http://www.fehcom.de/ipnet/ucspi-ssl.html"
SRC_URI="http://www.fehcom.de/ipnet/ucspi-ssl/${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="perl"

DEPEND="dev-libs/openssl:=
	net-libs/libnsl
	perl? ( dev-lang/perl:= )"
RDEPEND="${DEPEND}
	sys-apps/ucspi-tcp"

S="${WORKDIR}"/host/superscript.com/net/${P}

src_prepare() {
	ht_fix_all

	sed -i -e 's:auto:gcc:' conf-cc || die
	sed -i -e 's:-m64::' conf-ld || die
	qmail_set_cc

	echo "/usr/bin" > conf-tcpbin || die
	echo "/usr/share/ca-certificates/" > conf-cadir || die
	echo "${QMAIL_HOME}/control/dh1024.pem" > conf-dhfile || die
	echo "/usr/" > src/home || die
	sed -i -e 's:HOME/command:/usr/bin:' \
		src/sslcat.sh src/sslconnect.sh src/https\@.sh || die

	eapply_user
}

src_compile() {
	cd src || die
	emake sysdeps
	emake uint32.h
	emake
}

src_install() {
	dodoc doc/*
	doman man/*.*

	cd src || die
	dobin $(<../package/commands-base)
	use perl && dobin $(<../package/commands-sslperl)
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fixheadtails qmail

DESCRIPTION="Command-line tools for building SSL client-server applications"
HOMEPAGE="https://www.fehcom.de/ipnet/ucspi-ssl.html"
SRC_URI="https://www.fehcom.de/ipnet/ucspi-ssl/${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~m68k ppc ppc64 ~s390 sparc x86"
IUSE="bindist perl"

DEPEND="
	dev-libs/openssl:0=[bindist=]
	perl? ( dev-lang/perl:= )"
RDEPEND="${DEPEND}
	sys-apps/ucspi-tcp"

S="${WORKDIR}"/host/superscript.com/net/${P}

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

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

	# workaround: SSL_TXT_ECDH is always set in openssl/ssl.h, even with openssl[bindist]
	sed -i -e 's:SSL_TXT_ECDH:ENABLE_SSL_TXT_ECDH:' src/ucspissl.h src/ssl_params.c conf-ecdh || die
	if use bindist; then
		echo > conf-ecdh || die
	fi
	default
}

src_compile() {
	cd src || die
	emake sysdeps
	emake uint32.h
	emake
}

src_install() {
	dodoc -r doc/.
	doman man/*

	cd src || die
	dobin $(<../package/commands-base)
	use perl && dobin $(<../package/commands-sslperl)
}

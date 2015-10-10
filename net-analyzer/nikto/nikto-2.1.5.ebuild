# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Web Server vulnerability scanner"
HOMEPAGE="http://www.cirt.net/Nikto2"
SRC_URI="http://www.cirt.net/nikto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ssl"

RDEPEND="
	dev-lang/perl
	>=net-libs/libwhisker-2.5
	ssl? (
		dev-libs/openssl:0=
		dev-perl/Net-SSLeay
	)"

src_prepare() {
	sed -i -e 's:config.txt:nikto.conf:g' plugins/* || die
	sed -i -e 's:/etc/nikto.conf:/etc/nikto/nikto.conf:;
	s:# EXECDIR=/usr/local/nikto:EXECDIR=/usr/share/nikto:;
	s:# use LW2:use LW2:;
	s:require "$CONFIGFILE{'\''PLUGINDIR'\''}/LW2.pm":# require "$CONFIGFILE{'\''PLUGINDIR'\''}/LW2.pm":;' nikto.pl || die
}

src_compile() { :; }

src_install() {
	insinto /etc/nikto
	doins nikto.conf

	dobin nikto.pl
	dosym nikto.pl /usr/bin/nikto

	insinto /usr/share/nikto
	doins -r plugins templates databases

	NIKTO_PMS='JSON-PP.pm'
	einfo "symlinking ${NIKTO_PMS} to ${VENDOR_LIB}"

	for _PM in ${NIKTO_PMS}; do
		_TARGET=${VENDOR_LIB}/${_PM}
		dosym /usr/share/nikto/plugins/${_PM} ${_TARGET}
	done

	dodoc docs/*.txt
	dohtml docs/nikto_manual.html
}

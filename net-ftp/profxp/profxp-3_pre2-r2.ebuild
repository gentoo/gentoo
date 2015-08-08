# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="FXP (server-to-server FTP) commandline client written in Perl"
HOMEPAGE="http://duncanthrax.net/profxp/"
SRC_URI="http://duncanthrax.net/profxp/profxp-v${PV/_/-}-src.tar.gz
	http://search.cpan.org/src/CLINTDW/SOCKS-0.03/lib/Net/SOCKS.pm"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="virtual/perl-Time-HiRes
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Perl"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack profxp-v${PV/_/-}-src.tar.gz
	cp "${DISTDIR}"/SOCKS.pm "${S}"/
}

src_prepare() {
	sed -i 's:/home/tom/ActivePerl-5\.6:/usr:' "${S}"/profxpv3.pl || die
}

src_compile() {
	:;
}

src_install() {
	perl_set_version
	newbin profxpv3.pl profxp.pl
	dosym profxp.pl /usr/bin/profxp
	insinto ${ARCH_LIB}/Net
	doins SOCKS.pm
	insinto ${ARCH_LIB}/${PN}
	doins ${PN}/*.pm
}

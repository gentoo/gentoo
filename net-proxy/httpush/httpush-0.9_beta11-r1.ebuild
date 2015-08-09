# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="${P/_beta/b}"

DESCRIPTION="Httpush is an intercepting proxy, allowing user to modify HTTP requests on-the-fly"
HOMEPAGE="http://httpush.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86"
IUSE="xml"

RDEPEND="dev-perl/URI
	virtual/perl-MIME-Base64
	dev-perl/libwww-perl
	dev-perl/Net-SSLeay
	dev-perl/Crypt-SSLeay
	dev-perl/HTML-Parser
	xml? ( dev-perl/XML-Twig )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	if ! use xml ; then
		echo
		einfo "If you'd like to use httpush's learning mode, please CTRL-C now"
		einfo "and enable the xml USE flag."
		epause 3
		echo
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i 's:^\(require httpush;\)$:push @INC, "/usr/lib/httpush";\n\1:' \
		httpush.pl || die "sed INC failed"
	sed -i 's:^\(.*DATADIR="\)data\(.*\)$:\1/var/lib/httpush\2:' *.pl \
		lib/plugin/broker.pm || die "sed DATADIR= failed"
}

src_install() {
	keepdir /var/lib/httpush

	insinto /usr/lib/httpush
	doins -r httpush.{dtd,lck,pem,pm} lib

	insinto /usr/share/httpush/plugins
	doins plugins/*

	newbin httpush.pl httpush
	newbin reindex.pl httpush-reindex
	ewarn "reindex script has been renamed httpush-reindex"

	dodoc README ChangeLog doc/*
}

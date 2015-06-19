# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/librg-utils-perl/librg-utils-perl-1.0.43.ebuild,v 1.3 2015/06/13 22:21:05 dilfridge Exp $

EAPI=5

inherit perl-module

DESCRIPTION="Parsers and format conversion utilities used by (e.g.) profphd"
HOMEPAGE="http://rostlab.org/"
SRC_URI="ftp://rostlab.org/librg-utils-perl/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-perl/List-MoreUtils"
DEPEND="${RDEPEND}
	sci-libs/profphd-utils
	dev-perl/Module-Build
"

src_configure() {
	econf
	perl-module_src_configure
}

src_install() {
	rm mat/Makefile* || die
	perl-module_src_install
	insinto /usr/share/${PN}
	doins -r mat
	exeinto /usr/share/${PN}
	doexe *.pl dbSwiss
	doman blib/libdoc/*
}

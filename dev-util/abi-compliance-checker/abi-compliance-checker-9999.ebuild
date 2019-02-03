# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="A tool for checking backward compatibility of a C/C++ library"
HOMEPAGE="http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
SRC_URI=""
EGIT_REPO_URI="https://github.com/lvc/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-util/abi-dumper
	dev-util/ctags"

src_install() {
	dodir /usr
	perl Makefile.pl --install --prefix="${EPREFIX}"/usr --destdir="${D}" || die
	einstalldocs
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#if LIVE
EGIT_REPO_URI="git://github.com/lvc/${PN}.git
	https://github.com/lvc/${PN}.git"

inherit git-r3
#endif

DESCRIPTION="A tool for checking backward compatibility of a C/C++ library"
HOMEPAGE="http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
SRC_URI="https://github.com/lvc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-util/ctags"

#if LIVE
SRC_URI=
KEYWORDS=
#endif

src_compile() {
	:
}

src_install() {
	mkdir -p "${D}"/usr || die
	perl Makefile.pl --install --prefix="${EPREFIX}"/usr --destdir="${D}" || die
}

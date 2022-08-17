# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A tool for checking backward compatibility of a C/C++ library"
HOMEPAGE="http://ispras.linuxbase.org/index.php/ABI_compliance_checker"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/lvc/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/lvc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"

RDEPEND="
	dev-util/abi-dumper
	dev-util/ctags
"
BDEPEND="dev-lang/perl"

src_install() {
	dodir /usr
	perl Makefile.pl --install --prefix="${EPREFIX}"/usr --destdir="${D}" || die
	einstalldocs
}

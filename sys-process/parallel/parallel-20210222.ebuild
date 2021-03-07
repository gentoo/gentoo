# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="A shell tool for executing jobs in parallel locally or on remote machines"
HOMEPAGE="https://www.gnu.org/software/parallel/ https://git.savannah.gnu.org/cgit/parallel.git/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="dev-lang/perl:=
	dev-perl/Devel-Size
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-IO"
DEPEND="${RDEPEND}"

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

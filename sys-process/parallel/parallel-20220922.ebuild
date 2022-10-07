# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/oletange.asc
inherit verify-sig

DESCRIPTION="A shell tool for executing jobs in parallel locally or on remote machines"
HOMEPAGE="https://www.gnu.org/software/parallel/ https://git.savannah.gnu.org/cgit/parallel.git/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.bz2.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-lang/perl
	dev-perl/Devel-Size
	dev-perl/Text-CSV
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-IO
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-oletange-20210423 )"

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

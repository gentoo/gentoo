# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/oletange.asc
inherit verify-sig

DESCRIPTION="Shell tool for executing jobs in parallel locally or on remote machines"
HOMEPAGE="https://www.gnu.org/software/parallel/ https://git.savannah.gnu.org/cgit/parallel.git/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnu/${PN}/${P}.tar.bz2.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~x64-macos"

RDEPEND="
	dev-lang/perl
	dev-perl/Devel-Size
	dev-perl/Text-CSV
"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-oletange-20210423 )"

src_configure() {
	# bug #908214
	unset PARALLEL_HOME

	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_compile() {
	# Silence a warning where it tries to use pod2pdf; force it to fallback
	# to pre-generated PDF.
	mkdir "${T}"/fake || die
	ln -s "${BROOT}"/bin/false "${T}"/fake/pod2pdf || die
	export PATH="${T}/fake:${PATH}"

	default
}

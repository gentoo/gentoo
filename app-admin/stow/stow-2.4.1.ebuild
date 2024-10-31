# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/adamspiers.asc
inherit perl-functions verify-sig

DESCRIPTION="GNU Stow is a symlink farm manager"
HOMEPAGE="https://www.gnu.org/software/stow/ https://git.savannah.gnu.org/cgit/stow.git"
SRC_URI="mirror://gnu/stow/${P}.tar.bz2"
SRC_URI+=" verify-sig? ( mirror://gnu/stow/${P}.tar.bz2.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~mips ~ppc ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-lang/perl:="
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		dev-perl/IO-stringy
		virtual/perl-Test-Harness
		dev-perl/Test-Output
	)
	verify-sig? ( sec-keys/openpgp-keys-adamspiers )
"

src_configure() {
	perl_set_version
	econf "--with-pmdir=${VENDOR_LIB}"
}

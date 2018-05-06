# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions

DESCRIPTION="GNU Stow is a symlink farm manager"
HOMEPAGE="https://www.gnu.org/software/stow/"
SRC_URI="mirror://gnu/stow/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

DEPEND="dev-lang/perl
	test? (
		dev-perl/IO-stringy
		virtual/perl-Test-Harness
		dev-perl/Test-Output
	)"
RDEPEND="dev-lang/perl:="

src_configure() {
	perl_set_version
	econf "--with-pmdir=${VENDOR_LIB}"
}

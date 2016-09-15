# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="GNU Stow is a symlink farm manager"
HOMEPAGE="https://www.gnu.org/software/stow/"
SRC_URI="mirror://gnu/stow/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

DEPEND="dev-lang/perl
	test? (
		virtual/perl-Test-Harness
		dev-perl/Test-Output
	)"
RDEPEND="dev-lang/perl"

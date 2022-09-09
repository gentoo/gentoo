# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PostScript Utilities"
HOMEPAGE="https://github.com/rrthomas/psutils http://web.archive.org/web/20110722005140/http://www.tardis.ed.ac.uk/~ajcd/psutils/"
SRC_URI="https://github.com/rrthomas/psutils/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

# Newer libpaper needed for fork which provides 'paper'
RDEPEND="
	>=app-text/libpaper-1.2.3
	>=dev-lang/perl-5.14
	dev-perl/IPC-Run3
"
BDEPEND="${RDEPEND}"

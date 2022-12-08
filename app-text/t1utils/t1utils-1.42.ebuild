# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Type 1 Font utilities"
SRC_URI="http://www.lcdf.org/type/${P}.tar.gz"
HOMEPAGE="http://www.lcdf.org/type/#t1utils"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
LICENSE="BSD"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!<media-libs/freetype-1.4_pre20080316"

DOCS=( NEWS.md README.md )

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A decoder for yENC format, popular on Usenet"
HOMEPAGE="https://yydecode.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/yydecode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.10-fix-strcmp-not-found.patch
)

src_prepare() {
	default
	sed -e "s/t3.sh//" -e "s/t7.sh//" -i checks/Makefile.in || die
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/898078
	#
	# Upstream has been dead since 2003. No bug reported.
	filter-lto
	default
}

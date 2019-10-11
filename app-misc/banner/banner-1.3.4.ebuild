# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The well known banner program for Linux"
HOMEPAGE="http://cedar-solutions.com/"
SRC_URI="${HOMEPAGE}ftp/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="!games-misc/bsd-games"
PATCHES=(
	"${FILESDIR}"/${PN}-1.3.3-ctype.h.patch
)

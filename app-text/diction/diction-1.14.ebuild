# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Diction and style checkers for english and german texts"
HOMEPAGE="https://www.gnu.org/software/diction/diction.html"
SRC_URI="http://www.moria.de/~michael/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ppc ~sparc x86 ~x64-macos"

DEPEND="
	sys-devel/gettext
	virtual/libintl
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.13-make.patch
)
DOCS=( NEWS README )

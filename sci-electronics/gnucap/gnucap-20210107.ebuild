# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNUCap is the GNU Circuit Analysis Package"
SRC_URI="https://git.savannah.gnu.org/cgit/gnucap.git/snapshot/${P}.tar.gz"
HOMEPAGE="http://www.gnucap.org/"

IUSE="examples"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="sys-libs/readline:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-respect-ldflags.patch"
	"${FILESDIR}/${P}-fix-paths.patch"
)

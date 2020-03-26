# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

DESCRIPTION="Displays info about resources used by a program"
HOMEPAGE="https://www.gnu.org/directory/time.html"
SRC_URI="mirror://gnu/time/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${PV}-info-dir-entry.patch
	"${FILESDIR}"/${P}-incorrect_memory_usage.patch
)

src_prepare() {
	default
	eautoreconf
}

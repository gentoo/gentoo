# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU Autoconf Macro Archive"
HOMEPAGE="https://www.gnu.org/software/autoconf-archive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
# Temporary patchset for 2024.10.16 because a snapshot is too awkward to make
# Can be dropped on next release
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-patches.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

# File collisions, bug #540246
RDEPEND="
	!=gnome-base/gnome-common-3.14.0-r0
	!>=gnome-base/gnome-common-3.14.0-r1[-autoconf-archive(+)]
"

PATCHES=(
	"${WORKDIR}"/${P}-patches
	"${FILESDIR}"/${P}-lua.patch
)

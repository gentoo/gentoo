# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="GNU Autoconf Macro Archive"
HOMEPAGE="https://www.gnu.org/software/autoconf-archive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# File collisions. #540246
RDEPEND="!=gnome-base/gnome-common-3.14.0-r0
	!>=gnome-base/gnome-common-3.14.0-r1[-autoconf-archive(+)]"
DEPEND=""

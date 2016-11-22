# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="GNU Autoconf Macro Archive"
HOMEPAGE="https://www.gnu.org/software/autoconf-archive/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

# File collisions. #540246
RDEPEND="!=gnome-base/gnome-common-3.14.0
	!>=gnome-base/gnome-common-3.14.0-r1[-autoconf-archive(+)]"
DEPEND=""

src_install() {
	default
	rm -r "${ED}/usr/share/${PN}" || die
}

# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manual for the Info reader in GNU Emacs"
HOMEPAGE="https://www.gnu.org/software/emacs/
	https://www.gnu.org/software/texinfo/"
# misc/info.texi and emacs/doc{license,style}.texi from Emacs tarball
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"
S="${WORKDIR}/misc"

LICENSE="FDL-1.3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# Block against Emacs to avoid a duplicate entry in the Info directory
RDEPEND="!app-editors/emacs"
BDEPEND="sys-apps/texinfo"

src_compile() {
	makeinfo -I ../emacs info.texi || die
}

src_install() {
	doinfo info.info
}

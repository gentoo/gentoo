# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manual for the Info reader in GNU Emacs"
HOMEPAGE="https://www.gnu.org/software/emacs/
	https://www.gnu.org/software/texinfo/"
# We need only info.info from the Emacs tarball, but package its source too:
# bsdtar -cJvf ${P}.tar.xz -s "%.*/%${P}/%" --include="*/misc/info.texi" \
# --include="*/misc/doclicense.texi" --include="*/emacs/docstyle.texi" \
# --include="*/info/info.info" @emacs-${PV}.tar.xz
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="FDL-1.3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

src_install() {
	doinfo info.info
}

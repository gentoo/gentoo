# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs mode for handling freedesktop.org desktop entry files"
HOMEPAGE="https://gitlab.freedesktop.org/xdg/desktop-file-utils"
SRC_URI="https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-${PV}.tar.xz"
S="${WORKDIR}"/desktop-file-utils-${PV}/misc

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

RDEPEND="!<dev-util/desktop-file-utils-0.27-r1[emacs(-)]"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}

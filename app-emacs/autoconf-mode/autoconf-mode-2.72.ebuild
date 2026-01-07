# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs major modes for editing autoconf and autotest input"
HOMEPAGE="https://www.gnu.org/software/autoconf/autoconf.html"
SRC_URI="mirror://gnu/autoconf/autoconf-${PV}.tar.xz"
S="${WORKDIR}/autoconf-${PV}/lib/emacs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

SITEFILE="50${PN}-gentoo.el"

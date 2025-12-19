# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for GNU gettext PO files"
HOMEPAGE="https://www.gnu.org/software/gettext/"

SRC_URI="mirror://gnu/gettext/gettext-${PV}.tar.xz"
S="${WORKDIR}/gettext-${PV}/gettext-tools/emacs"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

ELISP_REMOVE="start-po.el"
SITEFILE="50${PN}-gentoo.el"

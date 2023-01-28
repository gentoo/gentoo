# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25

inherit elisp

DESCRIPTION="Major mode for editing Poke programs"
HOMEPAGE="https://elpa.gnu.org/packages/poke-mode.html"
# Rehosted ELPA tarballs for compression.
SRC_URI="https://dev.gentoo.org/~arsen/poke-mode-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

ELISP_REMOVE="poke-mode-pkg.el"
SITEFILE="50${PN}-gentoo.el"

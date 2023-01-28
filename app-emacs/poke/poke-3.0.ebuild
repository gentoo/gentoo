# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25

inherit elisp

DESCRIPTION="Emacs meets GNU poke!"
HOMEPAGE="https://elpa.gnu.org/packages/poke.html"
# Rehosted ELPA tarballs for compression.
SRC_URI="https://dev.gentoo.org/~arsen/poke-${PV}.tar.gz -> ${P}-el.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-emacs/poke-mode"
RDEPEND="
	${DEPEND}
	>=dev-util/poke-3.0
"

ELISP_REMOVE="poke-pkg.el"
ELISP_TEXINFO="poke-el.texi"
# -el here used to disambiguate with the dev-util/poke package, which
# ships two more editing modes (for .map files and .pks files)
SITEFILE="50${PN}-el-gentoo.el"

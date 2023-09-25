# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs mode to edit OpenSCAD files"
HOMEPAGE="https://github.com/openscad/emacs-scad-mode"
SRC_URI="https://github.com/openscad/emacs-scad-mode/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/emacs-${P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

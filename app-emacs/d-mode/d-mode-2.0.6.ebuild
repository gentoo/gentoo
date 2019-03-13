# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Emacs major mode for editing D code"
HOMEPAGE="https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode
	https://www.emacswiki.org/emacs/DMode"
SRC_URI="https://github.com/Emacs-D-Mode-Maintainers/Emacs-D-Mode/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/Emacs-D-Mode-2.0.6"
ELISP_PATCHES="${P}-emacs-24.4.patch"
SITEFILE="50${PN}-gentoo.el"

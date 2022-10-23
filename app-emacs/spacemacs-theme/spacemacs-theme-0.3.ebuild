# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24

inherit elisp

DESCRIPTION="Emacs color theme that started as a theme for Spacemacs"
HOMEPAGE="https://github.com/nashamri/spacemacs-theme/"
SRC_URI="https://github.com/nashamri/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

DOCS=( README.md img )
ELISP_REMOVE="spacemacs-theme-pkg.el"
SITEFILE="50${PN}-gentoo.el"

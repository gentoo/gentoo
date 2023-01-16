# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Customizable tabs plugin for GNU Emacs"
HOMEPAGE="https://github.com/ema2159/centaur-tabs/"
SRC_URI="https://github.com/ema2159/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/powerline"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

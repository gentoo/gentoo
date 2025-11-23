# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Run a JavaScript interpreter in an Emacs inferior process window"
HOMEPAGE="https://github.com/redguardtoo/js-comint/"
SRC_URI="https://github.com/redguardtoo/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

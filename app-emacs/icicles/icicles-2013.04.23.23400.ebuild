# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Minibuffer input completion and cycling"
HOMEPAGE="https://www.emacswiki.org/emacs/Icicles"
SRC_URI="https://github.com/emacsmirror/icicles/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

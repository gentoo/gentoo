# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Minibuffer input completion and cycling"
HOMEPAGE="https://www.emacswiki.org/emacs/Icicles"
# Snapshot of https://github.com/emacsmirror/icicles.git
# PV is <Version>.<Update #> from header of icicles.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="A major emacs mode for editing Rust source code"
HOMEPAGE="https://www.rust-lang.org/"
SRC_URI="https://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

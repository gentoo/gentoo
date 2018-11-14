# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Major modes for MATLAB .m and .tlc files"
HOMEPAGE="http://matlab-emacs.sourceforge.net/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x86-macos"

S="${WORKDIR}/matlab-emacs"
SITEFILE="50${PN}-gentoo.el"
DOCS="README INSTALL ChangeLog*"

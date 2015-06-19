# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/rust-mode/rust-mode-1_beta20150411.ebuild,v 1.1 2015/04/11 20:55:34 jauhien Exp $

EAPI=5

inherit elisp

DESCRIPTION="A major emacs mode for editing Rust source code"
HOMEPAGE="http://www.rust-lang.org/"
SRC_URI="http://dev.gentoo.org/~jauhien/distfiles/${P}.tar.gz"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Generate u-boat-death messages, patterned after Iron Coffins"
HOMEPAGE="http://www.splode.com/~friedman/software/emacs-lisp/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

# Noah Friedman and Bob Manson have confirmed that this is in the public domain
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"

SITEFILE="50${PN}-gentoo.el"

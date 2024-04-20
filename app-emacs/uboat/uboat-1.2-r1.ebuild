# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Generate u-boat-death messages, patterned after Iron Coffins"
HOMEPAGE="http://www.splode.com/~friedman/software/emacs-lisp/"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.bz2"

# Noah Friedman and Bob Manson have confirmed that this is in the public domain
LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=( "${FILESDIR}/${P}-iap.patch" )
SITEFILE="50${PN}-gentoo.el"

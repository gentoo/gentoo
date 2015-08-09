# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp eutils

DESCRIPTION="Quilt mode for Emacs"
HOMEPAGE="http://satoru-takeuchi.org/dev/quilt-el/"
SRC_URI="http://satoru-takeuchi.org/dev/${PN}/download/${P}.tar.gz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sparc x86"

RDEPEND="dev-util/quilt"

ELISP_PATCHES="${P}-tramp-recursion.patch
	${PN}-0.45.4-header-window.patch"
SITEFILE="50${PN}-gentoo.el"
DOCS="README changelog"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Scheme tab-completion and word-completion for Emacs"
HOMEPAGE="http://synthcode.com/"
SRC_URI="http://synthcode.com/emacs/${P}.el.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"

SITEFILE="60${PN}-gentoo.el"

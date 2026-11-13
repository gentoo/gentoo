# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Mode for editing crontab files"
HOMEPAGE="https://www.mahalito.net/~harley/elisp/"
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.tar.bz2"

LICENSE="GPL-2" # GPL-2 only
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"

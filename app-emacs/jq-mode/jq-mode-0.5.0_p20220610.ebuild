# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=071c1c29bac30351ad338136f2b625e5601365cd
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Emacs major mode for editing jq queries"
HOMEPAGE="https://github.com/ljos/jq-mode/"
SRC_URI="https://github.com/ljos/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"  # tests fail, also they only test the ob integration

RDEPEND="app-misc/jq"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

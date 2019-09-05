# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

COMMIT="cf58dbec5394280503eb5502938f3b5445d1b53d"
DESCRIPTION="Major mode for editing SCSS files in Emacs"
HOMEPAGE="https://github.com/antonj/scss-mode"
SRC_URI="https://github.com/antonj/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-ruby/sass"

S="${WORKDIR}/${PN}-${COMMIT}"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.org"

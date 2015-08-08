# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

GITHUB_SHA1=b010d134f499c4b4ad33fe8a669a81e9a531b0b2

DESCRIPTION="Major mode for editing SCSS files in Emacs"
HOMEPAGE="https://github.com/antonj/scss-mode"
SRC_URI="${HOMEPAGE}/archive/${GITHUB_SHA1}.tar.gz -> ${P}-git.tar.gz"
S="${WORKDIR}/${PN}-${GITHUB_SHA1}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DOCS="README.org"
SITEFILE="50${PN}-gentoo.el"

DEPEND="dev-ruby/sass"

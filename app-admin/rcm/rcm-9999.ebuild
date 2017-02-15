# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="rc file (dotfile) management"
HOMEPAGE="https://github.com/thoughtbot/rcm"
EGIT_REPO_URI="https://github.com/thoughtbot/rcm.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""

DEPEND="dev-ruby/mustache"
RDEPEND=""

src_prepare () {
	./autogen.sh || die
	default
}

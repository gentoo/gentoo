# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="rc file (dotfile) management"
HOMEPAGE="https://github.com/thoughtbot/rcm"
SRC_URI="https://thoughtbot.github.io/${PN}/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-util/cram )"

src_test() {
	emake -j1 check
}

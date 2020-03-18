# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="rc file (dotfile) management"
HOMEPAGE="https://github.com/thoughtbot/rcm"
SRC_URI="https://thoughtbot.github.io/${PN}/dist/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-util/cram )"

src_test() {
	emake -j1 check
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-fakegem

DESCRIPTION="RKelly Remix is a fork of the RKelly JavaScript parser"
HOMEPAGE="https://github.com/nene/rkelly-remix"

LICENSE="MIT"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="doc"

each_ruby_test() {
	${RUBY} -S testrb-2 -Ilib:. test/test_*.rb test/*/test_*.rb || die
}

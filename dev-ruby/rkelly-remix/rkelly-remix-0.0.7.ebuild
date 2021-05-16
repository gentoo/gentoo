# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

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

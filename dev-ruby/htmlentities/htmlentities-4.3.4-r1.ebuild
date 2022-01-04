# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.txt"

inherit ruby-fakegem

DESCRIPTION="A simple library for encoding/decoding entities in (X)HTML documents"
HOMEPAGE="https://github.com/threedaymonk/htmlentities"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

each_ruby_test() {
	${RUBY} -Ilib:. -S testrb-2 test/*_test.rb || die "tests failed"
}

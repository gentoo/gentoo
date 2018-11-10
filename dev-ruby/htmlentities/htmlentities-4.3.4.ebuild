# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt"

inherit ruby-fakegem

DESCRIPTION="A simple library for encoding/decoding entities in (X)HTML documents"
HOMEPAGE="https://github.com/threedaymonk/htmlentities"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-macos"
IUSE=""

each_ruby_test() {
	${RUBY} -Ilib:. -S testrb-2 test/*_test.rb || die "tests failed"
}

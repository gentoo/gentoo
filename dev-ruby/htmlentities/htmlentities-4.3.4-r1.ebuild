# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.txt"

inherit ruby-fakegem

DESCRIPTION="A simple library for encoding/decoding entities in (X)HTML documents"
HOMEPAGE="https://github.com/threedaymonk/htmlentities"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

each_ruby_test() {
	${RUBY} -Ilib:. -S testrb-2 test/*_test.rb || die "tests failed"
}

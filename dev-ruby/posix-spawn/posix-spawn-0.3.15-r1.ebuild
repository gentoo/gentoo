# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="README.md TODO HACKING"

RUBY_FAKEGEM_EXTENSIONS=(ext/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="Library that implements a subset of the Ruby 1.9 Process::spawn"
HOMEPAGE="https://github.com/rtomayko/posix-spawn/"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="test"

all_ruby_prepare() {
	sed -i -e '/test_backtick_redirect/askip "Output depends on bash version"' test/test_backtick.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each {|f| require f}' || die
}

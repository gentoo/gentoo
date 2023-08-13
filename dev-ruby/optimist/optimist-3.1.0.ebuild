# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="FAQ.txt History.txt README.md"

inherit ruby-fakegem

DESCRIPTION="A commandline option parser for Ruby that just gets out of your way"
HOMEPAGE="https://www.manageiq.org/optimist/"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="3"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/chronic )"

all_ruby_prepare() {
	sed -i -e '/bundle/ s:^:#:' Rakefile || die
	sed -i -e 's/MiniTest/Minitest/' test/*_test.rb test/optimist/*_test.rb || die
}

each_ruby_test() {
	MUTANT=true ${RUBY} -S rake test || die "Tests failed."
}

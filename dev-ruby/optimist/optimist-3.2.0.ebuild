# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="FAQ.txt CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A commandline option parser for Ruby that just gets out of your way"
HOMEPAGE="https://www.manageiq.org/optimist/"
LICENSE="MIT"

SLOT="3"
KEYWORDS="~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/chronic )"

all_ruby_prepare() {
	sed -i -e '/bundle/ s:^:#:' Rakefile || die
	sed -i -e 's/MiniTest/Minitest/' test/*_test.rb test/optimist/*_test.rb || die
}

each_ruby_test() {
	MUTANT=true ${RUBY} -S rake test || die "Tests failed."
}

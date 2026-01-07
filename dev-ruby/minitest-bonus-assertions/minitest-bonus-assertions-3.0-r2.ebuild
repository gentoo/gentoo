# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Bonus assertions for minitest"
HOMEPAGE="https://github.com/halostatue/minitest-bonus-assertions"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest dev-ruby/minitest-pretty_diff )"

all_ruby_prepare() {
	sed -e '/\(bisect\|focus\|moar\)/ s:^:#:' \
		-e '1igem "minitest", "~> 5.0"' \
		-i test/minitest_config.rb || die

	sed -e '/returns true if the \(keys are missing\|sets are not equal\)/askip "Flaky"' \
		-i test/test_minitest-bonus-assertions.rb || die

	# Avoid test that returns slightly different formatting on ruby31
	sed -e '/is triggered with a different exception/askip "Fragile for output differences"' \
		-i test/test_minitest-bonus-assertions.rb || die

	# Avoid test that returns slightly different formatting with newer set versions.
	sed -e '207iskip "Fragile for output differences"' \
		-e '225iskip "Fragile for output differences"' \
		-i test/test_minitest-bonus-assertions.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

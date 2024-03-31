# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Bonus assertions for minitest"
HOMEPAGE="https://github.com/halostatue/minitest-bonus-assertions"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest dev-ruby/minitest-pretty_diff )"

all_ruby_prepare() {
	sed -i -e '/\(bisect\|focus\|moar\)/ s:^:#:' test/minitest_config.rb || die

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

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Bonus assertions for minitest"
HOMEPAGE="https://github.com/halostatue/minitest-bonus-assertions"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest dev-ruby/minitest-pretty_diff )"

all_ruby_prepare() {
	sed -i -e '/\(bisect\|focus\|moar\)/ s:^:#:' test/minitest_config.rb || die

	sed -i -e '/returns true if the \(keys are missing\|sets are not equal\)/askip "Flaky"' test/test_minitest-bonus-assertions.rb || die

	# Avoid test that returns slightly different formatting on ruby31
	sed -i -e '/is triggered with a different exception/askip "Fragile for output differences"' test/test_minitest-bonus-assertions.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_TASK_DOC="doc"

inherit ruby-fakegem

DESCRIPTION="Cri is a library for building easy-to-use commandline tools"
HOMEPAGE="https://rubygems.org/gems/cri"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="test"

ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/yard dev-ruby/minitest )"

all_ruby_prepare() {
	sed -e '/coveralls/I s:^:#:' -i test/helper.rb || die
	sed -i -e '/rubocop/ s:^:#:' \
		-e '/RuboCop/,/end/ s:^:#:' Rakefile || die

	sed -e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib -S rake test_unit || die
}

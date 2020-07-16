# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_TASK_DOC="doc"

inherit ruby-fakegem

DESCRIPTION="Cri is a library for building easy-to-use commandline tools"
HOMEPAGE="https://rubygems.org/gems/cri"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/yard dev-ruby/minitest )"

all_ruby_prepare() {
	sed -e '/coveralls/I s:^:#:' -i test/helper.rb || die
	sed -i -e '/rubocop/ s:^:#:' \
		-e '/RuboCop/,/end/ s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib -S rake test_unit || die
}

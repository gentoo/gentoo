# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A gem providing 'time travel' and 'time freezing' capabilities"
HOMEPAGE="https://github.com/travisjeffery/timecop"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

# Missing testdep activesupport
ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' -e '/History.rdoc/d' Rakefile test/test_helper.rb || die
	sed -i -e '/rubygems/ a\gem "test-unit"' \
		-e '/minitest\/rg/ s:^:#:' -e '/pry/ s:^:#:' test/test_helper.rb || die
	# FIXME after activesupport gained ruby22 support
	rm test/time_stack_item_test.rb || die
}

each_ruby_test() {
	for f in test/*_test.rb ; do
		${RUBY} -Ilib $f || die
	done
}

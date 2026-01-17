# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"
RUBY_FAKEGEM_GEMSPEC="timecop.gemspec"

inherit ruby-fakegem

DESCRIPTION="A gem providing 'time travel' and 'time freezing' capabilities"
HOMEPAGE="https://github.com/travisjeffery/timecop"
SRC_URI="https://github.com/travisjeffery/timecop/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

USE_RUBY="ruby32 ruby33 ruby34" ruby_add_bdepend "test? ( dev-ruby/activesupport dev-ruby/mocha )"
USE_RUBY="ruby40" ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -e '/bundler/ s:^:#:' -e '/History.rdoc/d' \
		-i Rakefile test/test_helper.rb test/timecop_with_active_support_test.rb || die
	sed -i -e '/rubygems/ a\gem "test-unit"' \
		-e '/minitest\/rg/ s:^:#:' -e '/pry/ s:^:#:' test/test_helper.rb || die
}

each_ruby_prepare() {
	case ${RUBY} in
		*ruby40)
			# Temporarily avoid activesupport to break a circular dependency
			rm -f test/time_stack_item_test.rb test/timecop_with_active_support_test.rb || die
			;;
	esac
}

each_ruby_test() {
	for f in test/*_test.rb ; do
		${RUBY} -Ilib $f || die
	done
}

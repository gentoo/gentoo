# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

# no documentation is generable, it needs hanna, which is broken
RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_EXTRADOC="CHANGES README.md doc/*"

RUBY_FAKEGEM_GEMSPEC="rack-cache.gemspec"

inherit ruby-fakegem

DESCRIPTION="Enable HTTP caching for Rack-based applications that produce freshness info"
HOMEPAGE="https://github.com/rtomayko/rack-cache"
SRC_URI="https://github.com/rtomayko/rack-cache/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.2"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "dev-ruby/rack:*"

ruby_add_bdepend "test? (
	>=dev-ruby/maxitest-3.4.0
	>=dev-ruby/minitest-5.7.0:5
	>=dev-ruby/mocha-0.13.0 )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' \
		test/test_helper.rb || die
}

all_ruby_prepare() {
	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/ s:^:#:' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib:test -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}

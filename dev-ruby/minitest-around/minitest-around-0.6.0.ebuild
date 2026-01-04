# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="minitest-around.gemspec"

inherit ruby-fakegem

DESCRIPTION="Alternative for setup/teardown dance"
HOMEPAGE="https://github.com/splattael/minitest-around"
SRC_URI="https://github.com/splattael/minitest-around/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

ruby_add_rdepend "|| ( dev-ruby/minitest:6 dev-ruby/minitest:5 )"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-util/cucumber )"

all_ruby_prepare() {
	sed -e '/bump/ s:^:#:' \
		-e '/ls-files/d' \
		-i minitest-around.gemspec Rakefile || die
	sed -e '/bundler/ s:^:#:' \
		-i test/test_helper.rb Rakefile || die
}

each_ruby_prepare() {
	sed -e "/spawn_test/,/^end/ s:ruby:${RUBY}:" \
		-i test/around_spec.rb || die
}

each_ruby_test() {
	for f in test/*_{test,spec}.rb ; do
		export RUBYLIB=lib
		${RUBY} ${f} || die
	done
}

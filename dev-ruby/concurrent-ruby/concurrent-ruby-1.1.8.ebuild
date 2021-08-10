# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Modern concurrency tools including agents, futures, promises, thread pools, more"
HOMEPAGE="https://github.com/ruby-concurrency/concurrent-ruby"
SRC_URI="https://github.com/ruby-concurrency/concurrent-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/timecop-0.7.4 )"

all_ruby_prepare() {
	# Remove edge files as defined in support/file_map.rb
	rm -rf spec/concurrent/{actor,cancellation,channel,edge,lazy_register,promises,throttle}* || die
	rm -r spec/concurrent/executor/wrapping_executor_spec.rb || die
	sed -i -e '/concurrent-edge/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's:lib-edge:lib/concurrent-ruby:' .rspec || die
	sed -i -e 's:../../../::' spec/concurrent/executor/executor_quits.rb || die

	# Remove specs for the ext gem
	rm -rf spec/concurrent/atomic || die

	sed -i 's/git ls-files/find . -print/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

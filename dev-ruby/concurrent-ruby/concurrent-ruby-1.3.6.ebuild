# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Modern concurrency tools including agents, futures, promises, thread pools, more"
HOMEPAGE="https://github.com/ruby-concurrency/concurrent-ruby"
SRC_URI="https://github.com/ruby-concurrency/concurrent-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/timecop-0.9 )"

all_ruby_prepare() {
	# Remove edge files as defined in support/file_map.rb
	rm -rf spec/concurrent/{actor,cancellation,channel,edge,lazy_register,processing,promises,throttle}* || die
	rm -r spec/concurrent/executor/wrapping_executor_spec.rb || die
	sed -i -e '/concurrent-edge/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's:lib-edge:lib/concurrent-ruby:' .rspec || die
	sed -i -e 's:../../../::' spec/concurrent/executor/executor_quits.rb || die

	# Remove specs for the ext gem
	rm -rf spec/concurrent/atomic || die

	sed -e 's/git ls-files/find * -print/' \
		-e "s/__dir__/'.'/" \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.md Performance.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A high performance pure Ruby client for accessing memcached servers"
HOMEPAGE="https://github.com/petergoldstein/dalli"
SRC_URI="https://github.com/petergoldstein/dalli/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND+="${DEPEND} test? ( >=net-misc/memcached-1.5.4 )"

ruby_add_bdepend "test? (
		dev-ruby/minitest:5
		>=dev-ruby/mocha-0.13
		dev-ruby/rack
		dev-ruby/activesupport:5.2
		dev-ruby/connection_pool )"

all_ruby_prepare() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	sed -i -e '/\(appraisal\|bundler\)/ s:^:#:' Rakefile || die

	sed -i -e '3igem "minitest", "~> 5.0"; gem "activesupport", "~>5.2.0"' \
		-e '/bundler/ s:^:#:' test/helper.rb || die

	# Drop rails dependency which is only used to display the version
	# number, so we only need to depend on activesupport and avoid
	# complicated circular dependencies.
	sed -i -e '/rails/I s:^:#:' \
		-e '14irequire "active_support"' test/helper.rb || die

	# Fix test compatability with memcached 1.5.4 and higher
	# https://github.com/petergoldstein/dalli/pull/672
	sed -i -e '/memcached_low_mem_persistent/,/^end/ s/-M/-M -I 512k/' test/memcached_mock.rb || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

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
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc64 ~x86"
IUSE=""

DEPEND+="${DEPEND} test? ( >=net-misc/memcached-1.4.0 )"

ruby_add_bdepend "test? (
		dev-ruby/minitest:5
		>=dev-ruby/mocha-0.13
		dev-ruby/rack
		>=dev-ruby/activesupport-4.1
		dev-ruby/connection_pool )"

all_ruby_prepare() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	sed -i -e '/\(appraisal\|bundler\)/ s:^:#:' Rakefile || die

	sed -i -e '1igem "minitest", "~> 5.0"' \
		-e '/bundler/ s:^:#:' test/helper.rb || die

	# Drop rails dependency which is only used to display the version
	# number, so we only need to depend on activesupport and avoid
	# complicated circular dependencies.
	sed -i -e '/rails/I s:^:#:' \
		-e '14irequire "active_support"' test/helper.rb || die
}

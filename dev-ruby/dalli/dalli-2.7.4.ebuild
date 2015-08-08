# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.md Performance.md README.md"

inherit ruby-fakegem

DESCRIPTION="A high performance pure Ruby client for accessing memcached servers"
HOMEPAGE="http://github.com/mperham/dalli"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND+="${DEPEND} test? ( >=net-misc/memcached-1.4.0 )"

ruby_add_bdepend "test? (
		>=dev-ruby/minitest-4.2.0
		>=dev-ruby/mocha-0.13
		>=dev-ruby/activesupport-4.1 )"

all_ruby_prepare() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	sed -i -e '/\(appraisal\|bundler\)/ s:^:#:' Rakefile || die

	sed -i -e '1igem "minitest", "~> 5.0"' test/helper.rb || die

	# Drop rails dependency which is only used to display the version
	# number, so we only need to depend on activesupport and avoid
	# complicated circular dependencies.
	sed -i -e '/rails/I s:^:#:' test/helper.rb || die
}

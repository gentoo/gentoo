# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dalli/dalli-2.6.4.ebuild,v 1.9 2014/08/12 21:21:05 blueness Exp $

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
		dev-ruby/minitest:0
		>=dev-ruby/mocha-0.13
		>=dev-ruby/activesupport-3 )"

all_ruby_prepare() {
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	sed -i -e '/appraisal/ s:^:#:' Rakefile || die

	sed -i -e '1igem "minitest", "~> 4.0"' test/helper.rb || die

	# Drop rails dependency which is only used to display the version
	# number, so we only need to depend on activesupport and avoid
	# complicated circular dependencies.
	sed -i -e '/rails/I s:^:#:' test/helper.rb || die
}

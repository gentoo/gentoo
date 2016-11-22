# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="HISTORY README.rdoc TODO"

inherit ruby-fakegem

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers"
HOMEPAGE="http://oauth.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

ruby_add_bdepend "test? (
		dev-ruby/test-unit:2
		dev-ruby/mocha:0.14
		dev-ruby/webmock
		dev-ruby/rack )"

all_ruby_prepare() {
	# Require a compatible version of mocha
	sed -i -e '1igem "mocha", "~> 0.14.0"' test/test_helper.rb || die

	# Ensure a consistent test order to avoid loading issues with e.g. rack
	sed -i -e "s/.rb']/.rb'].sort/" Rakefile || die

	# Remove tests that require Rails 2.3 since that is ruby18-only.
	rm -f test/test_action_controller_request_proxy.rb || die

	# Remove typhoeus tests since they require an old version.
	rm -f test/test_typhoeus_request_proxy.rb || die
}

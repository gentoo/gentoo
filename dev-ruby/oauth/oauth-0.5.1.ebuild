# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="HISTORY README.rdoc TODO"

inherit ruby-fakegem

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers"
HOMEPAGE="https://github.com/oauth-xx/oauth-ruby"
SRC_URI="https://github.com/oauth-xx/oauth-ruby/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-ruby-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86-macos"
IUSE=""

ruby_add_bdepend "test? (
		dev-ruby/test-unit:2
		dev-ruby/mocha:1.0
		dev-ruby/webmock
		dev-ruby/rack )"

all_ruby_prepare() {
	# Require a compatible version of mocha
	sed -i -e '1igem "mocha", "~> 1.0"' \
		-e '2i gem "test-unit"; require "test/unit"' \
		-e '/byebug/ s:^:#:' test/test_helper.rb || die

	# Remove tests that require Rails 2.3 since that is ruby18-only.
	rm -f test/test_action_controller_request_proxy.rb || die

	# Remove typhoeus tests since they require an old version.
	rm -f test/test_typhoeus_request_proxy.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}

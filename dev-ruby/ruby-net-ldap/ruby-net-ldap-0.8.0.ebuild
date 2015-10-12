# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# jruby: requires ruby 1.9 compatibility
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST="test spec"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Contributors.rdoc History.rdoc README.rdoc"

RUBY_FAKEGEM_NAME="net-ldap"

inherit ruby-fakegem

DESCRIPTION="Pure ruby LDAP client implementation"
HOMEPAGE="https://github.com/ruby-ldap/ruby-net-ldap"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/flexmock-1.3.0
	>=dev-ruby/metaid-1
	dev-ruby/test-unit:2
	dev-ruby/rspec:2 )"

all_ruby_prepare() {
	sed -i -e '1igem "test-unit"' test/common.rb || die

	# Fix Specs until RSpec:3 is in tree
	sed -i -e 's/truthy/true/' spec/unit/ldap_spec.rb || die
	# Avoid an integration spec that hangs due to setting up pipes and
	# intercepting openssl connect calls.
	rm spec/integration/ssl_ber_spec.rb || die
}

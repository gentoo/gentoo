# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

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

ruby_add_bdepend "test? ( >=dev-ruby/flexmock-1.3.0 )"

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}

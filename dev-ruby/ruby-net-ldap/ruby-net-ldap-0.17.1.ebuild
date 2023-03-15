# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST="test spec"
RUBY_FAKEGEM_EXTRADOC="Contributors.rdoc History.rdoc README.rdoc"

RUBY_FAKEGEM_NAME="net-ldap"

RUBY_FAKEGEM_GEMSPEC="net-ldap.gemspec"

inherit ruby-fakegem

DESCRIPTION="Pure ruby LDAP client implementation"
HOMEPAGE="https://github.com/ruby-ldap/ruby-net-ldap"
SRC_URI="https://github.com/ruby-ldap/ruby-net-ldap/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/flexmock-1.3.0 )"

all_ruby_prepare() {
	sed -i -e "s:_relative ': './:" ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}

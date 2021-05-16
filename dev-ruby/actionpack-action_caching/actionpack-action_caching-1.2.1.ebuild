# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="Action caching for Action Pack (removed from core in Rails 4.0)"
HOMEPAGE="https://github.com/rails/actionpack-action_caching"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/actionpack-4.0.0:*"

ruby_add_bdepend "test? ( >=dev-ruby/activerecord-4.0.0
	dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" Rakefile test/abstract_unit.rb || die
	sed -i -e "/git/d" ${PN}.gemspec || die
	sed -i -e "2irequire 'mocha/setup'" test/caching_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test test/caching_test.rb || die
}

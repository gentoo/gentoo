# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby33 ruby34"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Advisory locking for ActiveRecord"
HOMEPAGE="https://github.com/ClosureTree/with_advisory_lock"
SRC_URI="https://github.com/ClosureTree/with_advisory_lock/archive/refs/tags/${PN}/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="test"

# Requires database connection, additional BDEPEND packages (dev-ruby/dotenv, minitest-reporters)
RESTRICT="test"

ruby_add_rdepend "
	|| ( dev-ruby/activerecord:8.1 dev-ruby/activerecord:8.0 dev-ruby/activerecord:7.2 )
"
ruby_add_bdepend "test? (
	|| (
		dev-ruby/activerecord:8.1[mysql,postgres]
		dev-ruby/activerecord:8.0[mysql,postgres]
		dev-ruby/activerecord:7.2[mysql,postgres]
	)
	>=dev-ruby/maxitest-6.2.0
	dev-ruby/mocha
	dev-ruby/yard
)
"

all_ruby_unpack() {
	default
	mv "${WORKDIR}/all/${PN}-${PN}-v${PV}" "${WORKDIR}/all/${P}" || die
}

all_ruby_prepare() {
	sed -i -e "s:require_relative 'lib:require './lib:" ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e "/git ls-files/d" with_advisory_lock.gemspec || die

	sed -e '3igem "activerecord", "<8"' \
		-i test/test_helper.rb || die
	rm -fr bin
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_TASK_TEST="-Ilib test"

inherit ruby-fakegem

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	dev-ruby/nio4r:2
	>=dev-ruby/websocket-driver-0.6.1:*
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "
	test? (
		|| ( dev-ruby/rack:3.2 dev-ruby/rack:3.1 dev-ruby/rack:3.0 dev-ruby/rack:2.2 )
		>=dev-ruby/railties-4.2.0
		dev-ruby/activerecord:$(ver_cut 1-2)
		dev-ruby/test-unit:2
		dev-ruby/mocha
		>=dev-ruby/pg-1.1:1
		www-servers/puma
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
	)"

all_ruby_prepare() {
	sed -e '2igem "minitest", "~> 6.0"; gem "minitest-mock"; require "pathname"' \
		-i test/test_helper.rb || die

	# Avoid tests for unpackaged dependencies: websocket-client-simple
	rm -f test/client_test.rb || die

	# Avoid tests for dependencies that require additional setup or network
	rm -f test/javascript_package_test.rb test/subscription_adapter/redis_test.rb || die
}

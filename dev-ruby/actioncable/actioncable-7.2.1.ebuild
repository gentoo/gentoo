# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_EXTRAINSTALL="app"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
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
		>=dev-ruby/railties-4.2.0
		dev-ruby/test-unit:2
		dev-ruby/mocha
		>=dev-ruby/pg-1.1:1
	)"

all_ruby_prepare() {
	# Avoid tests for unpackaged dependencies: websocket-client-simple
	rm -f test/client_test.rb || die

	# Avoid tests for dependencies that require additional setup or network
	rm -f test/javascript_package_test.rb test/subscription_adapter/redis_test.rb || die
}

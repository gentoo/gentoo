# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_DOCDIR=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_DOC=""

inherit edo ruby-fakegem

DESCRIPTION="Integrated WebSockets for Rails"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~x86"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}:*
	~dev-ruby/activesupport-${PV}:*
	dev-ruby/nio4r:2
	>=dev-ruby/websocket-driver-0.6.1:*
	>=dev-ruby/zeitwerk-2.6:2
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/minitest:5
		>=www-servers/puma-5.0.3:*
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 5.0"

	gem "puma", ">= 5.0.3"
	EOF
	rm ../Gemfile.lock || die

	# Avoid tests for unpackaged dependencies: websocket-client-simple
	rm -f test/client_test.rb || die

	# Avoid tests for dependencies that require additional setup or network
	rm -f test/javascript_package_test.rb \
		test/subscription_adapter/postgresql_test.rb \
		test/subscription_adapter/redis_test.rb || die
}

each_ruby_test() {
	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake
}

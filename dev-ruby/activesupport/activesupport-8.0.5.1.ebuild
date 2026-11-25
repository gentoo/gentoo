# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"
RUBY_FAKEGEM_GEMSPEC="activesupport.gemspec"

inherit edo ruby-fakegem

DESCRIPTION="Utility Classes and Extension to the Standard Library"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

IUSE="+msgpack test"
REQUIRED_USE="test? ( msgpack )"

ruby_add_rdepend "
	dev-ruby/base64
	>=dev-ruby/benchmark-0.3
	dev-ruby/bigdecimal
	>=dev-ruby/concurrent-ruby-1.3.1:1
	>=dev-ruby/connection_pool-2.2.5
	dev-ruby/drb
	>=dev-ruby/i18n-1.6:1
	>=dev-ruby/logger-1.4.2
	>=dev-ruby/minitest-5.1:*
	>=dev-ruby/securerandom-0.3
	>=dev-ruby/tzinfo-2.0:2
	>=dev-ruby/uri-0.13.1
	msgpack? ( >=dev-ruby/msgpack-1.7.0 )
"
ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		<dev-ruby/dalli-5:*
		>=dev-ruby/dalli-3.0.1:*
		>=dev-ruby/listen-3.3:3
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
		dev-ruby/rexml
	)
"

PATCHES=( "${FILESDIR}/${PN}-7.1.1-backport-pr50097.patch" )

all_ruby_prepare() {
	# Set the secure permissions that tests expect.
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 6.0"
	gem "minitest-mock"

	gem "dalli", ">= 3.0.1", "< 5"
	gem "listen", "~> 3.3"
	gem "msgpack", ">= 1.7.0"
	gem "rexml"
	EOF
	rm ../Gemfile.lock || die

	# Avoid tests requiring a live redis running
	rm -f test/cache/stores/redis_cache_store_test.rb || die
	sed -e '/cache_stores:redis/ s:^:#:' -i Rakefile || die
	sed -e '/test_redis_cache_store/askip "lacking keywords"' -i test/cache/cache_store_setting_test.rb || die
}

each_ruby_test() {
	# Allow the minitest rails plugin to be found.
	local -x  RUBYLIB=../railties/lib

	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake
}

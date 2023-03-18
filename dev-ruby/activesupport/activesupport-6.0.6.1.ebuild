# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_TASK_TEST="MT_NO_PLUGINS=true"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activesupport.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Utility Classes and Extension to the Standard Library"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	>=dev-ruby/concurrent-ruby-1.0.2:1
	dev-ruby/i18n:1
	>=dev-ruby/tzinfo-1.1:1
	>=dev-ruby/minitest-5.1:5
	>=dev-ruby/zeitwerk-2.2:2
"

# memcache-client, nokogiri, builder, and redis are not strictly needed,
# but there are tests using this code.
ruby_add_bdepend "test? (
	>=dev-ruby/dalli-2.2.1
	>=dev-ruby/nokogiri-1.4.5
	>=dev-ruby/builder-3.1.0
	>=dev-ruby/listen-3.0.5:3
	dev-ruby/rack
	dev-ruby/mocha
	<dev-ruby/minitest-5.16:5
	)"

all_ruby_prepare() {
	# Set the secure permissions that tests expect.
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|mysql\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|minitest\|sprockets\|stackprof\|rack-cache\|redis\|sqlite\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' \
		-e 's/gemspec/gemspec path: "activesupport"/' \
		-e '5igem "builder"; gem "rack"' ../Gemfile || die
	rm ../Gemfile.lock || die
	sed -i -e '1igem "tzinfo", "~> 1.1"; gem "psych", "~> 3.0"' test/abstract_unit.rb || die

	# Avoid test that depends on timezone
	sed -i -e '/test_implicit_coercion/,/^  end/ s:^:#:' test/core_ext/duration_test.rb || die

	# Avoid tests that seem to trigger race conditions.
	rm -f test/evented_file_update_checker_test.rb || die

	# Avoid test that generates filename that is too long
	sed -i -e '/test_filename_max_size/askip "gentoo"' test/cache/stores/file_store_test.rb || die

	# Avoid tests requiring a live redis running
	rm -f test/cache/stores/redis_cache_store_test.rb || die
	sed -i -e '/cache_stores:redis/ s:^:#:' Rakefile || die
	sed -i -e '/test_redis_cache_store/askip "lacking keywords"' test/cache/cache_store_setting_test.rb || die
}

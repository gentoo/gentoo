# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activesupport.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem versionator

DESCRIPTION="Utility Classes and Extension to the Standard Library"
HOMEPAGE="https://github.com/rails/rails"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	>=dev-ruby/i18n-0.7:0.7
	>=dev-ruby/tzinfo-1.1:1
	>=dev-ruby/minitest-5.1:5
	>=dev-ruby/thread_safe-0.3.4:0"

# memcache-client, nokogiri, and builder are not strictly
# needed, but there are tests using this code.
ruby_add_bdepend "test? (
	>=dev-ruby/dalli-2.2.1
	>=dev-ruby/nokogiri-1.4.5
	>=dev-ruby/builder-3.1.0
	dev-ruby/rack
	dev-ruby/mocha:0.14
	)"

all_ruby_prepare() {
	# Set the secure permissions that tests expect.
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	sed -i -e "/\(system_timer\|sdoc\|w3c_validators\|pg\|execjs\|jquery-rails\|mysql\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|sprockets-rails\|redcarpet\|bcrypt\|uglifier\|minitest\|mime-types\|sprockets\|stackprof\|rack-cache\|sqlite\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' \
		-e 's/gemspec/gemspec path: "activesupport"/' \
		-e '5igem "builder"; gem "rack"' ../Gemfile || die
	rm ../Gemfile.lock || die

	# Avoid test that seems to be broken by lack of DST.
	sed -i -e '369 s:^:#:' test/core_ext/string_ext_test.rb || die

	# Avoid test that fails with Minitest 5.4 since that already defines
	# a string E in its TestCase.
	rm test/core_ext/marshal_test.rb || die
	sed -i -e '/test_const_missing_in_anonymous_modules/askip "gentoo minitest"' test/dependencies_test.rb || die
}

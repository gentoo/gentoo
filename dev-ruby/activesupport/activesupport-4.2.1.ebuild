# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activesupport/activesupport-4.2.1.ebuild,v 1.1 2015/03/19 19:23:13 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

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
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	>=dev-ruby/i18n-0.7:0.7
	>=dev-ruby/json-1.7.7:0
	>=dev-ruby/tzinfo-1.1:1
	>=dev-ruby/minitest-5.1:5
	>=dev-ruby/thread_safe-0.3.4:0"

# memcache-client, nokogiri, and builder are not strictly
# needed, but there are tests using this code.
ruby_add_bdepend "test? (
	>=dev-ruby/dalli-2.2.1
	>=dev-ruby/nokogiri-1.4.5
	>=dev-ruby/builder-3.1.0
	>=dev-ruby/libxml-2.0.0
	)"

all_ruby_prepare() {
	# Set the secure permissions that tests expect.
	chmod 0755 "${HOME}" || die "Failed to fix permissions on home"

	# Set test environment to our hand.
#	rm "${S}/../Gemfile" || die "Unable to remove Gemfile"
	sed -i -e '/load_paths/d' test/abstract_unit.rb || die "Unable to remove load paths"

	# Avoid test that seems to be broken by lack of DST.
	sed -i -e '369 s:^:#:' test/core_ext/string_ext_test.rb || die

	# Avoid test that fails with Minitest 5.4 since that already defines
	# a string E in its TestCase.
	rm test/core_ext/marshal_test.rb || die
	sed -i -e '/test_const_missing_in_anonymous_modules/askip "gentoo minitest"' test/dependencies_test.rb || die
}

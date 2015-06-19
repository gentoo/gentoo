# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/activesupport/activesupport-4.0.13.ebuild,v 1.1 2015/01/07 07:03:48 graaff Exp $

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
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "
	>=dev-ruby/multi_json-1.3:0
	>=dev-ruby/i18n-0.6.9:0.6
	>=dev-ruby/tzinfo-0.3.37:0
	>=dev-ruby/minitest-4.2:0
	>=dev-ruby/thread_safe-0.1:0
	!!<dev-ruby/activesupport-3.0.11-r1:3.0"

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

	# Make sure a compatible version of minitest is used everywhere.
	sed -i -e "s/gem 'minitest'/gem 'minitest', '~> 4.2'/" lib/active_support/test_case.rb || die
	sed -i -e "1igem 'minitest', '~> 4.2'" test/abstract_unit.rb || die

	# Avoid test that seems to be broken by lack of DST.
	sed -i -e '324 s:^:#:' test/core_ext/string_ext_test.rb || die
}

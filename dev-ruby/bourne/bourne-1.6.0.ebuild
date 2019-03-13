# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_TASK_TEST="MOCHA_OPTIONS=use_test_unit_gem test:units test:acceptance"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Extends mocha to allow tracking and querying of stub and mock invocations"
HOMEPAGE="https://github.com/thoughtbot/bourne"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/mocha-1.5.0:1.0"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' "${RUBY_FAKEGEM_GEMSPEC}" || die
	sed -i -e '/bundler/d' Rakefile || die

	# Fix tests to work with mocha 1.5.0 or newer where reset_instance is gone
	sed -i -e '/reset_instance/ s:^:#:' test/unit/*received_test.rb || die
	sed -i -e 's/Mockery.reset_instance/mocha_teardown/' test/unit/mockery_test.rb || die
}

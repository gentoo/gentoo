# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"
RUBY_FAKEGEM_EXTRAINSTALL="locales"
inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="https://github.com/rsl/stringex"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/i18n-0.7.0:1
		>=dev-ruby/redcloth-4.2.9
		>=dev-ruby/test-unit-3.0.9:2
	)
"

each_ruby_prepare() {
	if has_version "dev-ruby/activerecord[ruby_targets_${_ruby_implementation},sqlite]" ; then
		einfo "Testing activerecord integration"
	else
		rm -f test/unit/acts_as_url_integration_test.rb || die
		# These tests fails when the acts_as_url code is not loaded
		# through the above integration test.
		rm -f test/unit/unicode_point_suite/basic_{greek,latin}_test.rb || die
	fi
}

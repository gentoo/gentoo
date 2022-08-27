# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30"

inherit ruby-fakegem

DESCRIPTION="Extensions for Ruby's String class"
HOMEPAGE="https://github.com/rsl/stringex"
LICENSE="MIT"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "
	test? (
		dev-ruby/i18n:1
		dev-ruby/redcloth
		dev-ruby/test-unit:2
		)"

all_ruby_prepare() {
	# Let tests work with newer rails versions
	sed -i -e 's/update_attributes/update/' test/unit/acts_as_url/adapter/* || die
}

each_ruby_prepare() {
	if has_version "dev-ruby/activerecord[ruby_targets_${_ruby_implementation},sqlite]" ; then
		einfo "Testing activerecord integration"
	else
		rm -f test/unit/acts_as_url_integration_test.rb || die
	fi
}

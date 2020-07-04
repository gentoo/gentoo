# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="faker.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library for generating fake data such as names, addresses, and phone numbers"
HOMEPAGE="https://github.com/stympy/faker"
SRC_URI="https://github.com/stympy/faker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/i18n-1.6 !!<dev-ruby/faker-1.9.6-r1"

ruby_add_bdepend "test? ( dev-ruby/timecop )"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|rubocop\)/I s:^:#:' Rakefile || die
	sed -i -e '/simplecov/,/^end/ s:^:#:' test/test_helper.rb || die
}

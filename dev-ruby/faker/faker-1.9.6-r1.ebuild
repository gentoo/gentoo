# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="faker.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A library for generating fake data such as names, addresses, and phone numbers"
HOMEPAGE="https://github.com/stympy/faker"
SRC_URI="https://github.com/stympy/faker/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/i18n-0.7:*"

ruby_add_bdepend "test? ( dev-ruby/timecop )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^end/ s:^:#:' test/test_helper.rb || die
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_DOC="none"

RUBY_FAKEGEM_GEMSPEC="faker.gemspec"

inherit ruby-fakegem

DESCRIPTION="A library for generating fake data such as names, addresses, and phone numbers"
HOMEPAGE="https://github.com/faker-ruby/faker"
SRC_URI="https://github.com/faker-ruby/faker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/i18n-1.8.11:1"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 dev-ruby/timecop )"

all_ruby_prepare() {
	sed -e '/simplecov/,/^end/ s:^:#:' \
		-e '2igem "minitest", "~> 5.0"' \
		-i test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/test*.rb"].each { require _1 }' || die
}

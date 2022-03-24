# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Preview mail in the browser instead of sending"
HOMEPAGE="https://github.com/ryanb/letter_opener"
SRC_URI="https://github.com/ryanb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/mail-2.6:* )"
ruby_add_rdepend ">=dev-ruby/launchy-2.2:0"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile spec/spec_helper.rb || die
	sed -i -e '4irequire "letter_opener"' spec/spec_helper.rb || die

	# Avoid tests that require some kind of browser
	sed -i -e '/opens email/askip "requires installed browser"' spec/letter_opener/delivery_method_spec.rb || die
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="General Rack Authentication Framework"
HOMEPAGE="https://github.com/wardencommunity/warden"
SRC_URI="https://github.com/wardencommunity/warden/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/rack-2.0.9:*"

ruby_add_bdepend "test? ( dev-ruby/rack:2.2 )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '1igem "rack", "<3"' spec/spec_helper.rb || die
}

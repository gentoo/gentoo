# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRAINSTALL="assets"

inherit ruby-fakegem

DESCRIPTION="HTML formatter for Cucumber"
HOMEPAGE="https://cucumber.io/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend "
	>=dev-util/cucumber-messages-15.0.0:15
"

all_ruby_prepare() {
	sed -i -e '1igem "cucumber-messages", "~>15.0"' spec/html_formatter_spec.rb || die
}

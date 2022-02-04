# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="HTML formatter for Cucumber"
HOMEPAGE="https://cucumber.io/"
LICENSE="Ruby"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv"
SLOT="$(ver_cut 1)"
IUSE="test"

ruby_add_rdepend "
	>=dev-util/cucumber-messages-17.0.1:17
	>=dev-ruby/sys-uname-1.2.2:1
"

all_ruby_prepare() {
	sed -i -e '1igem "cucumber-messages", "~>17.0"' spec/cucumber/create_meta_spec.rb || die
}

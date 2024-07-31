# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

inherit ruby-fakegem

DESCRIPTION="Utility-belt to build form data request bodies"
HOMEPAGE="https://github.com/httprb/form_data.rb"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/SimpleCov.start/ s:^:#: ; 1irequire "json"' spec/spec_helper.rb || die
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Internal HashiCorp service to check version information"
HOMEPAGE="https://www.hashicorp.com"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

# Tests require network
RESTRICT="test"

ruby_add_bdepend "
	test? ( dev-ruby/rspec-its )
"

all_ruby_prepare() {
	# remove bundler support
	sed -i '/[Bb]undler/d' Rakefile || die

	# Make tests compatible with new ruby versions
	sed -i -e '/check/ s/opts/**opts/' spec/checkpoint_spec.rb || die
}

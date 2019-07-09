# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="Changelog.md CONTRIBUTING.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Attributes on Steroids for Plain Old Ruby Objects"
HOMEPAGE="https://github.com/solnic/virtus https://rubygems.org/gems/virtus"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-equalizer.patch" )

ruby_add_rdepend ">=dev-ruby/axiom-types-0.1
	<dev-ruby/axiom-types-1
	>=dev-ruby/coercible-1.0
	<dev-ruby/coercible-2
	>=dev-ruby/descendants_tracker-0.0.3
	<dev-ruby/descendants_tracker-1
	>=dev-ruby/equalizer-0.0.9
	<dev-ruby/equalizer-1"

ruby_add_bdepend "test? (
	dev-ruby/inflecto
	dev-ruby/bogus
)"

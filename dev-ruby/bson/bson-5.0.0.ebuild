# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTENSIONS=(ext/bson/extconf.rb)

inherit ruby-fakegem

DESCRIPTION="A Ruby BSON implementation for MongoDB. (Includes binary C-based extension.)"
HOMEPAGE="https://www.mongodb.com/"
# We prefer rubygems if we can anyway, but note that rubygems has test sources we need,
# but github *doesn't* (other way around to usual!)
RUBY_S="bson-ruby-${PV}"

LICENSE="APSL-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test doc"

ruby_add_rdepend "dev-ruby/base64 dev-ruby/bigdecimal"

all_ruby_prepare() {
	# Remove bundler support
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

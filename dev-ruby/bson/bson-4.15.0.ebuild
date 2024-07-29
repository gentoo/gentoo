# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTENSIONS=(ext/bson/extconf.rb)

GITHUB_USER="mongodb"
GITHUB_PROJECT="bson-ruby"

inherit ruby-fakegem

DESCRIPTION="A Ruby BSON implementation for MongoDB. (Includes binary C-based extension.)"
HOMEPAGE="https://www.mongodb.org/"
# We prefer rubygems if we can anyway, but note that rubygems has test sources we need,
# but github *doesn't* (other way around to usual!)
RUBY_S="bson-ruby-${PV}"

LICENSE="APSL-2"
SLOT="4"
KEYWORDS="~amd64"
IUSE="test doc"

ruby_add_rdepend "dev-ruby/json"

all_ruby_prepare() {
	# Remove bundler support
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

#RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Run shell commands safely, even with user-supplied values"
HOMEPAGE="https://github.com/thoughtbot/terrapin"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# posix-spawn is not a mandatory dependency but recommended in the
# README.
ruby_add_rdepend "dev-ruby/climate_control:0 dev-ruby/posix-spawn"

ruby_add_bdepend "
	test? (
		>=dev-ruby/activesupport-3  <dev-ruby/activesupport-5
		dev-ruby/bourne
		dev-ruby/mocha
	)"

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app"

inherit ruby-fakegem

DESCRIPTION="Ruby on Rails integration for the Javascript Data Visualization Framework, D3"
HOMEPAGE="https://github.com/logical42/d3_rails"

LICENSE="MIT BSD"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/railties-3.1:*"

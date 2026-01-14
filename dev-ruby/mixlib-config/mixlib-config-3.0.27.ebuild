# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRA_DOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="mixlib-config.gemspec"

inherit ruby-fakegem

DESCRIPTION="A class based configuration library"
HOMEPAGE="https://github.com/chef/mixlib-config"
SRC_URI="https://github.com/chef/mixlib-config/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

ruby_add_rdepend "dev-ruby/tomlrb"

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_RECIPE_DOC="yard"

inherit ruby-fakegem

DESCRIPTION="Define types with optional constraints for use within axiom and other libraries"
HOMEPAGE="https://rubygems.org/gems/axiom-types https://github.com/dkubb/axiom-types"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/descendants_tracker-0.0.4
	<dev-ruby/descendants_tracker-0.1
	>=dev-ruby/ice_nine-0.11.0
	<dev-ruby/ice_nine-0.12
	>=dev-ruby/thread_safe-0.3.1
	<dev-ruby/thread_safe-1"

RESTRICT="test"

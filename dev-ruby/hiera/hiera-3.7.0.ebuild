# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A simple pluggable Hierarchical Database"
HOMEPAGE="https://docs.puppet.com/hiera/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_bdepend "test? ( dev-ruby/mocha )"

ruby_add_rdepend "dev-ruby/deep_merge"

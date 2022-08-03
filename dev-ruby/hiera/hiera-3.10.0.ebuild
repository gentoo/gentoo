# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A simple pluggable Hierarchical Database"
HOMEPAGE="https://docs.puppet.com/hiera/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_bdepend "test? ( dev-ruby/mocha )"

ruby_add_rdepend "dev-ruby/deep_merge"

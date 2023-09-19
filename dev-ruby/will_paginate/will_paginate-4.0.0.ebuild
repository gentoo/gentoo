# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="will_paginate.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Most awesome pagination solution for Ruby"
HOMEPAGE="https://github.com/mislav/will_paginate/"
SRC_URI="https://github.com/mislav/will_paginate/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	# Remove tests for unpackaged ORMs
	rm -f spec/finders/{sequel,mongoid,data_mapper}* || die
}

ruby_add_bdepend "
	test? (
		dev-ruby/rails
		dev-ruby/activerecord[sqlite]
		dev-ruby/mocha
	)"

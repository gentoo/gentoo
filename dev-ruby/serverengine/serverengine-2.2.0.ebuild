# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="Changelog README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="A framework to implement robust multiprocess servers"
HOMEPAGE="https://github.com/fluent/serverengine"
LICENSE="Apache-2.0"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/sigdump-0.2.2:0"

ruby_add_bdepend "test? ( dev-ruby/bundler )"

all_ruby_prepare() {
	sed -i -e '/rake/ s/~>/>=/' \
		-e '/rspec/ s/2.13.0/2.13/' \
		-e '/rake-compiler/ s:^:#:' serverengine.gemspec || die
}

each_ruby_test() {
	# The specs spawn ruby processes with bundler support
	${RUBY} -S bundle exec rspec-2 spec || die
}

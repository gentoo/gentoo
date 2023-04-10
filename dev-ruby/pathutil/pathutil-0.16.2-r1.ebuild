# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_GEMSPEC="Gem.gemspec"

inherit ruby-fakegem

DESCRIPTION="Like Pathname but a little less insane"
HOMEPAGE="https://rubygems.org/gems/pathutil https://github.com/envygeeks/pathutil"
SRC_URI="https://github.com/envygeeks/pathutil/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-ruby30.patch" )

ruby_add_rdepend ">=dev-ruby/forwardable-extended-2.6
	<dev-ruby/forwardable-extended-3"

ruby_add_bdepend "test? ( dev-ruby/safe_yaml )"

all_ruby_prepare() {
	sed -i -e '/\(coverage\|luna\|rspec\/helpers\)/ s:^:#:' \
		-e '1irequire "pathname"; require "tempfile"; require "tmpdir"; require "json" ; gem "psych", "~> 3.0"' \
		spec/rspec/helper.rb || die
	rm -f spec/support/coverage.rb || die
}

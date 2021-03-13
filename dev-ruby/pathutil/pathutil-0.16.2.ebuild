# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
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

ruby_add_rdepend ">=dev-ruby/forwardable-extended-2.6
	<dev-ruby/forwardable-extended-3"

ruby_add_bdepend "test? ( dev-ruby/safe_yaml )"

all_ruby_prepare() {
	sed -i -e '/\(coverage\|luna\|rspec\/helpers\)/ s:^:#:' \
		-e '1irequire "pathname"; require "tempfile"; require "tmpdir"; require "json"' \
		spec/rspec/helper.rb || die
	rm -f spec/support/coverage.rb || die

	# Avoid spec failing with newer rspec versions, bug 775383
	sed -i -e '/should chdir before running the glob/apending' spec/tests/lib/pathutil_spec.rb || die
}

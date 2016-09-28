# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="README.markdown History.markdown"
RUBY_FAKEGEM_EXTRAINSTALL="features site"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

RUBY_FAKEGEM_BINDIR="exe"

DESCRIPTION="A simple, blog aware, static site generator"
HOMEPAGE="http://jekyllrb.com https://github.com/jekyll/jekyll"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz  -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/colorator-1.0
	>=dev-ruby/kramdown-1.3
	>=dev-ruby/liquid-3.0:3
	>=dev-ruby/mercenary-0.3.3
	>=dev-ruby/pathutil-0.9
	>=dev-ruby/safe_yaml-1.0
	>=dev-ruby/rouge-1.7
	>=www-apps/jekyll-sass-converter-1.0
	>=www-apps/jekyll-watch-1.1"

ruby_add_bdepend "test? (
		dev-ruby/rspec-mocks
		dev-ruby/launchy
		dev-ruby/mime-types:0
		>=dev-ruby/rdiscount-2.0
		>=dev-ruby/redcloth-4.2.1
		>=dev-ruby/rouge-1.7
		>=dev-ruby/shoulda-3
		dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e "/simplecov/,+5d"\
		-e "1igem 'test-unit'"\
		-e "1igem 'minitest', '~> 5.0'"\
		-e "/reporters/d"\
		-e "/profile/d"\
		-e "/Reporters/,+4d" test/helper.rb || die
	# Drop bundler
	sed -i -e "/self.class.require_from_bundler/d" lib/jekyll/plugin_manager.rb || die
	# This test fails without bundler
	rm test/test_plugin_manager.rb || die
	rm test/test_theme.rb || die
	# Replace git command in gemspec
	sed -i 's/git ls-files -z/find -not -type d -print0/' $RUBY_FAKEGEM_GEMSPEC || die
}

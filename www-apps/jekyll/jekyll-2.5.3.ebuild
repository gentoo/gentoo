# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.markdown README.markdown History.markdown"
RUBY_FAKEGEM_EXTRAINSTALL="features site"

DESCRIPTION="A simple, blog aware, static site generator"
HOMEPAGE="http://jekyllrb.com https://github.com/jekyll/jekyll"
SRC_URI="https://github.com/jekyll/${PN}/archive/v${PV}.tar.gz  -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/classifier-reborn
	dev-ruby/colorator
	>=dev-ruby/kramdown-1.3
	>=dev-ruby/liquid-2.6.1:0
	>=dev-ruby/mercenary-0.3.3
	>=dev-ruby/pygments_rb-0.6.0
	>=dev-ruby/redcarpet-3.1
	>=dev-ruby/safe_yaml-1
	dev-ruby/toml
	www-apps/jekyll-coffeescript
	www-apps/jekyll-gist
	www-apps/jekyll-paginate
	www-apps/jekyll-sass-converter
	www-apps/jekyll-watch"

ruby_add_bdepend "test? (
		dev-ruby/activesupport:3.2
		dev-ruby/launchy
		>=dev-ruby/maruku-0.7
		dev-ruby/mime-types:0
		=dev-ruby/rdiscount-1.6*
		>=dev-ruby/redcloth-4.2.1
		>=dev-ruby/rouge-1.7
		dev-ruby/rr
		>=dev-ruby/shoulda-3
		dev-ruby/test-unit:2 )"

all_ruby_prepare() {
	sed -i -e "/simplecov/,+5d" test/helper.rb || die
	sed -i -e "1igem 'test-unit'" test/helper.rb || die
	# Drop bundler
	sed -i -e "/self.class.require_from_bundler/d" lib/jekyll/plugin_manager.rb || die
	# This test fails without bundler
	rm test/test_plugin_manager.rb || die
}

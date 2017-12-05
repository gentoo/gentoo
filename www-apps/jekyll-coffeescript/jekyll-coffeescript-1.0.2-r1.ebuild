# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="README.md History.markdown"
RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

SRC_URI="https://github.com/jekyll/jekyll-coffeescript/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A CoffeeScript Converter for Jekyll"
HOMEPAGE="https://github.com/jekyll/jekyll-coffeescript"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile || die
	sed -i -e "/^RSpec/i \
		require 'jekyll'"\
		-e "/^RSpec/i \
		require 'jekyll-coffeescript'" spec/spec_helper.rb || die
}

ruby_add_rdepend ">=dev-ruby/coffee-script-2.2
	>=dev-ruby/coffee-script-source-1.11.1"
ruby_add_bdepend "test? ( www-apps/jekyll )"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md History.markdown"
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_GEMSPEC="jekyll-coffeescript.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/jekyll/jekyll-coffeescript/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="A CoffeeScript Converter for Jekyll"
HOMEPAGE="https://github.com/jekyll/jekyll-coffeescript"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

all_ruby_prepare() {
	sed -i -e '/bundler/d' Rakefile || die
	sed -i -e "/^RSpec/i \
		require 'jekyll'"\
		-e "/^RSpec/i \
		require 'jekyll-coffeescript'" spec/spec_helper.rb || die
	sed -i -e 's/git ls-files/find -type f -print/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

ruby_add_rdepend ">=dev-ruby/coffee-script-2.2
	>=dev-ruby/coffee-script-source-1.12"
ruby_add_bdepend "test? ( www-apps/jekyll )"

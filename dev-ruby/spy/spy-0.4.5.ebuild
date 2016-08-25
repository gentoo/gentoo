# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit multilib ruby-fakegem

DESCRIPTION="A simple opinionated mocking framework"
HOMEPAGE="https://github.com/ryanong/spy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:0
	dev-ruby/pry )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" -e "/pry-nav/d" -e "/[Cc]overalls/d" Rakefile test/test_helper.rb || die
}

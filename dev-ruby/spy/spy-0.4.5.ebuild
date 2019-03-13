# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit multilib ruby-fakegem

DESCRIPTION="A simple opinionated mocking framework"
HOMEPAGE="https://github.com/ryanong/spy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:0 )"

all_ruby_prepare() {
	sed -i -e "/bundler/d" -e "/pry/d" -e "/[Cc]overalls/d" Rakefile test/test_helper.rb || die
}

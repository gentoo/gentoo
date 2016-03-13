# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_RECIPE_TEST="rspec"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="An object-oriented AST extension for Parser"
HOMEPAGE="https://github.com/yujinakayama/astrolabe"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/parser-2.2.0_pre3"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	# Fix Specs until RSpec3 is available
	sed -i -e "/mocks.verify_partial_doubles/ s/^/#/" spec/spec_helper.rb || die
	sed -i -e "s/is_expected.to/should/" spec/astrolabe/node_spec.rb || die
}

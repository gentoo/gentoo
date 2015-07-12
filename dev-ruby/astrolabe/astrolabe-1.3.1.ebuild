# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/astrolabe/astrolabe-1.3.1.ebuild,v 1.1 2015/07/12 06:15:42 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

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

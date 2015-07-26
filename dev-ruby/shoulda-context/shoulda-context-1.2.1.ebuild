# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/shoulda-context/shoulda-context-1.2.1.ebuild,v 1.1 2015/07/20 05:43:49 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CONTRIBUTING.md README.md"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb rails tasks"

# Don't install the conversion script to avoid collisions with older
# shoulda.
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Context framework extracted from Shoulda"
HOMEPAGE="http://thoughtbot.com/projects/shoulda"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64"
IUSE="doc test"

ruby_add_bdepend "test? ( dev-ruby/test-unit:2
	<dev-ruby/mocha-1 )"

all_ruby_prepare() {
	sed -i -e "1igem 'mocha', '~>0.10'\n" test/test_helper.rb || die
}

each_ruby_test() {
	BUNDLE_GEMFILE=x ruby-ng_testrb-2 -Itest test/shoulda/*_test.rb || die
}

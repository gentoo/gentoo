# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
# ruby22 -> fails tests
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A minimal shoulda DSL built on top of MiniTest::Spec"
HOMEPAGE="https://github.com/seattlerb/minitest"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">dev-ruby/minitest-2.1.0"

all_ruby_prepare() {
	sed -i -e '/git ls-files/d' mini_shoulda.gemspec || die
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile test/test_helper.rb || die
}

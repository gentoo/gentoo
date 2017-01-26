# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Creates temporary files and directories for testing"
HOMEPAGE="https://github.com/bhb/test_construct"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"
IUSE=""

ruby_add_bdepend "test? (
	>=dev-ruby/minitest-5.0.8
	>=dev-ruby/mocha-0.14.0
	dev-ruby/rspec:3
)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/test_construct/test_construct-2.0.1.ebuild,v 1.4 2015/04/11 16:45:41 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="Creates temporary files and directories for testing"
HOMEPAGE="https://github.com/bhb/test_construct"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_bdepend "test? (
	>=dev-ruby/minitest-5.0.8
	>=dev-ruby/mocha-0.14.0
	dev-ruby/rspec:3
)"

all_ruby_prepare () {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

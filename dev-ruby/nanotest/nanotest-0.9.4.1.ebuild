# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/nanotest/nanotest-0.9.4.1.ebuild,v 1.1 2015/05/05 05:39:51 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Extremely mynymal test framework"
HOMEPAGE="https://github.com/mynyml/nanotest"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

each_ruby_test() {
	${RUBY} -I.:lib test/test_nanotest.rb || die
}

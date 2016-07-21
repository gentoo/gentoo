# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

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

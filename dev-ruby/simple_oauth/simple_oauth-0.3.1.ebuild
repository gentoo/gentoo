# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/simple_oauth/simple_oauth-0.3.1.ebuild,v 1.2 2015/03/25 20:34:06 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simply builds and verifies OAuth headers"
HOMEPAGE="https://github.com/laserlemon/simple_oauth"
SRC_URI="https://github.com/laserlemon/simple_oauth/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i -e "/simplecov/,+8d" spec/helper.rb || die

	sed -i -e '/files/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	export CI=true
	each_fakegem_test
}

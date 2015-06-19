# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rack-openid/rack-openid-1.4.2.ebuild,v 1.3 2015/04/27 05:55:53 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Readme.md"

inherit ruby-fakegem

DESCRIPTION="Provides a more HTTPish API around the ruby-openid library"
SRC_URI="https://github.com/grosser/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="https://github.com/grosser/rack-openid"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ruby-openid-2.1.8 >=dev-ruby/rack-1.1.0:*"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' -e '/minitest\/rg/d' -e '/[Ll]og/d' test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test_rack_openid.rb || die
	# Needs unpackaged rots dependency https://github.com/roman/rots
	# No release available right now
	#${RUBY} -Ilib test/test_integration.rb || die
}

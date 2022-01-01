# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="Readme.md"
RUBY_FAKEGEM_GEMSPEC="rack-openid.gemspec"

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

	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test_rack_openid.rb || die
	# Needs unpackaged rots dependency https://github.com/roman/rots
	# No release available right now
	#${RUBY} -Ilib test/test_integration.rb || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/http-cookie/http-cookie-1.0.2-r1.ebuild,v 1.4 2015/06/09 18:31:25 maekke Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A ruby library to handle HTTP cookies"
HOMEPAGE="https://github.com/sparklemotion/http-cookie"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/domain_name-0.5:0"

all_ruby_prepare() {
	sed -i -e "/simplecov/d" -e "/bundler/d" Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test_http_cookie.rb || die
	${RUBY} -Ilib test/test_http_cookie_jar.rb || die
}

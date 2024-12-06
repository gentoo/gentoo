# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A ruby library to handle HTTP cookies"
HOMEPAGE="https://github.com/sparklemotion/http-cookie"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# See https://github.com/sparklemotion/http-cookie/issues/16 for dropping domain_name
ruby_add_rdepend ">=dev-ruby/domain_name-0.5:0"

all_ruby_prepare() {
	sed -i -e "/simplecov/d" -e "/bundler/d" Rakefile || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test_http_cookie.rb || die
	${RUBY} -Ilib test/test_http_cookie_jar.rb || die
}

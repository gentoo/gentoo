# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md EXAMPLES.rdoc GUIDE.rdoc README.md"

inherit ruby-fakegem

DESCRIPTION="A Ruby library used for automating interaction with websites"
HOMEPAGE="https://github.com/sparklemotion/mechanize"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"

ruby_add_bdepend ">=dev-ruby/hoe-3.7
	test? ( dev-ruby/minitest:5 )"

ruby_add_rdepend "
	>=dev-ruby/addressable-2.8:0
	dev-ruby/base64
	>=dev-ruby/domain_name-0.5.20190701:0
	>=dev-ruby/http-cookie-1.0.3:0
	dev-ruby/mime-types:3
	>=dev-ruby/net-http-digest_auth-1.4.1:0
	dev-ruby/net-http-persistent:4
	dev-ruby/nkf
	>=dev-ruby/nokogiri-1.11.2:0
	>=dev-ruby/rubyntlm-0.6.3:0
	>=dev-ruby/webrick-1.7:0
	>=dev-ruby/webrobots-0.1.2 =dev-ruby/webrobots-0.1*
"

each_ruby_test() {
	${RUBY} -Ilib:.:test -e '$VERBOSE=true; Dir["test/**/test_*.rb"].each{|f| require f}' || die
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}

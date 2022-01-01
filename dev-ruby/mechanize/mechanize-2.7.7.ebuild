# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc EXAMPLES.rdoc GUIDE.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A Ruby library used for automating interaction with websites"
HOMEPAGE="https://github.com/sparklemotion/mechanize"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend ">=dev-ruby/hoe-3.7
	test? ( dev-ruby/minitest:5 )"
ruby_add_rdepend ">=dev-ruby/nokogiri-1.6
	>=dev-ruby/net-http-digest_auth-1.1.1
	>=dev-ruby/net-http-persistent-2.5.2:*
	>=dev-ruby/ntlm-http-0.1.1
	>=dev-ruby/webrobots-0.0.9
	>=dev-ruby/http-cookie-1.0.2
	>=dev-ruby/mime-types-1.17.2:*
	>=dev-ruby/domain_name-0.5.1
	>=dev-ruby/webrick-1.7:0"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}

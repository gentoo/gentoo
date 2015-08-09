# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc EXAMPLES.rdoc GUIDE.rdoc README.rdoc"

inherit ruby-fakegem

DESCRIPTION="A Ruby library used for automating interaction with websites"
HOMEPAGE="https://github.com/sparklemotion/mechanize"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_bdepend ">=dev-ruby/hoe-3.7
	test? ( dev-ruby/minitest:5 )"
ruby_add_rdepend ">=dev-ruby/nokogiri-1.4.4-r1
	>=dev-ruby/net-http-digest_auth-1.1.1
	>=dev-ruby/net-http-persistent-2.5.2
	>=dev-ruby/ntlm-http-0.1.1
	>=dev-ruby/webrobots-0.0.9
	>=dev-ruby/http-cookie-1.0.2
	>=dev-ruby/mime-types-2.0
	>=dev-ruby/domain_name-0.5.1"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/* || die
}

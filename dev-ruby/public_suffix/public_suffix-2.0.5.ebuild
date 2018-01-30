# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Parse and decompose a domain name into top level domain, domain and subdomains"
HOMEPAGE="https://simonecarletti.com/code/publicsuffix-ruby/"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
LICENSE="MIT"
SLOT="2"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e '/rubocop/I s:^:#:' \
		-e '/yardoc/,/end/ s:^:#:' \
		-e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/reporters/I s:^:#:' test/test_helper.rb || die
}

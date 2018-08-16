# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC="doc:rdoc"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="oauth2.gemspec"

inherit ruby-fakegem eutils

DESCRIPTION="Wrapper for the OAuth 2.0 protocol with a similar style to the OAuth gem"
HOMEPAGE="https://github.com/intridea/oauth2"
SRC_URI="https://github.com/intridea/oauth2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/faraday-0.8 <dev-ruby/faraday-0.15
	>=dev-ruby/jwt-1.0 =dev-ruby/jwt-1*
	>=dev-ruby/multi_json-1.3 =dev-ruby/multi_json-1*
	>=dev-ruby/multi_xml-0.5:0
	>=dev-ruby/rack-1.2:* <dev-ruby/rack-3:*"
ruby_add_bdepend "test? ( dev-ruby/rspec:3 )"

all_ruby_prepare() {
	sed -i -e '/faraday/ s/0.13/0.15/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/simplecov/,/^  end/ s:^:#:' \
		-e '1irequire "uri"' spec/helper.rb || die

	sed -i -e '/yardstick/,/^end/ s:^:#:' \
		-e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_test() {
	CI=true ${RUBY} -S rspec-3 spec || die
}

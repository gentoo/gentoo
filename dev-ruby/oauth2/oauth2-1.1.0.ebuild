# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="none"
RUBY_FAKEGEM_TASK_DOC="doc:rdoc"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem eutils

DESCRIPTION="Wrapper for the OAuth 2.0 protocol with a similar style to the OAuth gem"
HOMEPAGE="https://github.com/intridea/oauth2"
SRC_URI="https://github.com/intridea/oauth2/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/faraday-0.8
	>=dev-ruby/jwt-1.0 =dev-ruby/jwt-1*
	>=dev-ruby/multi_json-1.3 =dev-ruby/multi_json-1*
	>=dev-ruby/multi_xml-0.5:0
	>=dev-ruby/rack-1.2:*"
ruby_add_bdepend "test? ( >=dev-ruby/rspec-2.5.0:2 )"

all_ruby_prepare() {
	sed -i -e '/simplecov/,/^  end/ s:^:#:' spec/helper.rb || die

	sed -i -e '/yardstick/,/^end/ s:^:#:' \
		-e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_test() {
	CI=true ${RUBY} -S rspec spec || die
}

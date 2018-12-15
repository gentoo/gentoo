# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="API client for Nexpose vulnerability managment product"
HOMEPAGE="https://github.com/rapid7/nexpose-client https://rubygems.org/gems/nexpose"
SRC_URI="https://github.com/rapid7/nexpose-client/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="${PN}-client-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/vcr:3
	dev-ruby/webmock
)"

all_ruby_prepare() {
	sed -i -e '/\(codeclimate\|simplecov\)/ s:^:#:' \
		-e '/SimpleCov/,/^]/ s:^:#:' \
		-e '1irequire "nexpose"' spec/spec_helper.rb || die
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Faraday adapter for NetHttpPersistent"
HOMEPAGE="https://github.com/lostisland/faraday-net_http_persistent"
SRC_URI="https://github.com/lostisland/faraday-net_http_persistent/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/faraday-2.5:2
	dev-ruby/net-http-persistent:4
"

ruby_add_depend "test? (
	>=dev-ruby/webmock-3.4
)"

all_ruby_prepare() {
	sed -i -e "s:_relative ':'./:" ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Faraday adapter for Rack"
HOMEPAGE="https://github.com/lostisland/faraday-rack"
SRC_URI="https://github.com/lostisland/faraday-rack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/faraday:1
	|| ( dev-ruby/rack:3.0 dev-ruby/rack:2.2 )
	>=dev-ruby/rack-test-0.6
	dev-ruby/webmock
)"

all_ruby_prepare() {
	sed -i -e "s:_relative ':'./:" ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '2igem "faraday", "~> 1.0"; gem "rack", "<3.1"' spec/spec_helper.rb || die
}

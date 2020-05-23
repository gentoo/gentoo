# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="Secret User Agent of HTTP"
HOMEPAGE="https://github.com/lostisland/sawyer"
SRC_URI="https://github.com/lostisland/sawyer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "
	<dev-ruby/faraday-2.0:*
	>=dev-ruby/addressable-2.3.5"

all_ruby_prepare() {
	# Avoid tests that require network acces
	sed -i -e '/test_blank_response_doesnt_raise/,/^    end/ s:^:#:' test/agent_test.rb || die
}

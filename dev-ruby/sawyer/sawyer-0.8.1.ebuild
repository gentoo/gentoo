# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ruby25: code not compatible
USE_RUBY="ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit multilib ruby-fakegem

DESCRIPTION="Secret User Agent of HTTP"
HOMEPAGE="https://github.com/lostisland/sawyer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

ruby_add_rdepend "<dev-ruby/faraday-1.0
	>=dev-ruby/addressable-2.3.5 <dev-ruby/addressable-2.6"

all_ruby_prepare() {
	# Avoid tests that require network acces
	sed -i -e '/test_blank_response_doesnt_raise/,/^    end/ s:^:#:' test/agent_test.rb || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="sawyer.gemspec"

inherit ruby-fakegem

DESCRIPTION="Secret User Agent of HTTP"
HOMEPAGE="https://github.com/lostisland/sawyer"
SRC_URI="https://github.com/lostisland/sawyer/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

ruby_add_rdepend "
	<dev-ruby/faraday-3:*
	>=dev-ruby/addressable-2.3.5
"

all_ruby_prepare() {
	# Avoid tests that require network access
	sed -i -e '/test_blank_response_doesnt_raise/,/^    end/ s:^:#:' test/agent_test.rb || die

	# Account for different inspect output in Ruby 3.4
	sed -e '204 s/"{:a=>1}"/({:a=>1}).inspect/' \
		-i test/resource_test.rb || die
	sed -e '174 s|"{:self_url=>\\\"/users/1\\\"}"|({:self_url=>\"/users/1\"}).inspect|' \
		-i test/relation_test.rb || die
}

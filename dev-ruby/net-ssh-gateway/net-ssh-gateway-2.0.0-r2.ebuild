# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGES.txt README.md"
RUBY_FAKEGEM_GEMSPEC="net-ssh-gateway.gemspec"

inherit ruby-fakegem

DESCRIPTION="A simple library to assist in enabling tunneled Net::SSH connections"
HOMEPAGE="https://github.com/net-ssh/net-ssh-gateway"
SRC_URI="https://github.com/net-ssh/net-ssh-gateway/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2.0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

ruby_add_depend "dev-ruby/minitest:5
	dev-ruby/mocha:2"

ruby_add_rdepend ">=dev-ruby/net-ssh-4.0.0:*"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/bundler/ s:^:#:' Rakefile test/net/ssh/gateway_test.rb || die
	sed -e 's:mocha/mini_test:mocha/minitest:' \
		-e 's/MiniTest/Minitest/' \
		-i test/net/ssh/gateway_test.rb || die
}

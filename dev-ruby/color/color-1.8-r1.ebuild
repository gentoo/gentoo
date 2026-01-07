# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"
RUBY_FAKEGEM_GEMSPEC="color.gemspec"

inherit ruby-fakegem

DESCRIPTION="Colour management with Ruby"
HOMEPAGE="https://github.com/halostatue/color"
SRC_URI="https://github.com/halostatue/color/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/minitest-5.0:5
	)"

all_ruby_prepare() {
	sed -e '1igem "minitest", "~> 5.0"' \
		-i test/minitest_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}

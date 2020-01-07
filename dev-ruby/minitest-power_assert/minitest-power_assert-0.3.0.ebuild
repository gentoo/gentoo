# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Power Assert for Minitest"
HOMEPAGE="https://github.com/hsbt/minitest-power_assert"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend "
	dev-ruby/minitest:*
	>=dev-ruby/power_assert-1.1
"

all_ruby_prepare() {
	sed -i -e '/bundle/ s:^:#:' Rakefile || die
}

#each_ruby_test() {
#	${RUBY} -Ilib:.:test -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
#}

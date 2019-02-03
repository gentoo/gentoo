# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

inherit ruby-fakegem

DESCRIPTION="Provides plugin management for Ruby projects"
HOMEPAGE="https://github.com/ddfreyne/ddplugin/"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/coverall/I s:^:#:' test/helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/test_*.rb"].each{|f| require f}' || die
}

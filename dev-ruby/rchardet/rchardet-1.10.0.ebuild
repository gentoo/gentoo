# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="Readme.md"

RUBY_FAKEGEM_GEMSPEC="rchardet.gemspec"

inherit ruby-fakegem

DESCRIPTION="Character encoding auto-detection in Ruby"
HOMEPAGE="https://github.com/jmhodges/rchardet"
SRC_URI="https://github.com/jmhodges/rchardet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_depend "test? ( dev-ruby/minitest:5 dev-ruby/maxitest )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' -e '/minitest\/rg/ s:^:#:' test/test_helper.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/*_test.rb"].each{|f| require f}' || die
}

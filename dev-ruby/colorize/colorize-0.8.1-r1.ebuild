# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem

DESCRIPTION="Adds methods to set color, background color and text effect on console easier"
HOMEPAGE="https://github.com/fazibear/colorize"
LICENSE="GPL-2+"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	sed -i -e "/[Cc]ode[Cc]limate/d" test/test_colorize.rb || die
}

each_ruby_test() {
	cd test || die
	${RUBY} test_colorize.rb || die
}

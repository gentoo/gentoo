# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_TASK_TEST="default"

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

	# Skip unpackaged test as this release is not tagged upstream.
	sed -i -e '/test_\(colorize\|colorized_string\)_with_readline/,/execute/ s:^:#:' Rakefile || die
}

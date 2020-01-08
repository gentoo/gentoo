# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Methods for processing keyboard input in character, line and multiline modes"
HOMEPAGE="https://github.com/piotrmurach/tty-reader"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/tty-cursor-0.7:0
	>=dev-ruby/tty-screen-0.7:0
	=dev-ruby/wisper-2.0*
"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="tty-reader.gemspec"

inherit ruby-fakegem

DESCRIPTION="Methods for processing keyboard input in character, line and multiline modes"
HOMEPAGE="https://github.com/piotrmurach/tty-reader"
SRC_URI="https://github.com/piotrmurach/tty-reader/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/tty-cursor-0.7:0
	>=dev-ruby/tty-screen-0.8:0
	=dev-ruby/wisper-2*
"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' spec/spec_helper.rb || die
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

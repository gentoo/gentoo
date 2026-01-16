# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="tty-prompt.gemspec"

inherit ruby-fakegem

DESCRIPTION="A beautiful and powerful interactive command line prompt"
HOMEPAGE="https://github.com/piotrmurach/tty-prompt"
SRC_URI="https://github.com/piotrmurach/tty-prompt/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "
	>=dev-ruby/pastel-0.8:0
	>=dev-ruby/tty-reader-0.8:0
"

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
	sed -i -e 's:require_relative ":require "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}

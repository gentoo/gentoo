# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="tty-screen.gemspec"

inherit ruby-fakegem

DESCRIPTION="Terminal screen size detection which works on Linux, OS X and Windows/Cygwin"
HOMEPAGE="https://github.com/piotrmurach/tty-screen"
SRC_URI="https://github.com/piotrmurach/tty-screen/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
	sed -i -e 's:require_relative ":require "./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid performance specs. These depend on unpackaged
	# rspec-benchmark and are likely to fail on at least some Gentoo
	# systems.
	rm -f spec/perf/{screen,size}_spec.rb || die
}

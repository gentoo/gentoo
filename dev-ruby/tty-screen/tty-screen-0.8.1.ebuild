# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

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
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-ioctl-test.patch" )

all_ruby_prepare() {
	echo '-rspec_helper' > .rspec || die
	sed -i -e 's:require_relative ":require "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
	rm -f spec/perf/size_spec.rb || die
}

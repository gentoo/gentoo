# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="benchmark.gemspec"

inherit ruby-fakegem

DESCRIPTION="A performance benchmarking library"
HOMEPAGE="https://github.com/ruby/benchmark"
SRC_URI="https://github.com/ruby/benchmark/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Ruby BSD-2"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__FILE__/"benchmark.gemspec"/' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

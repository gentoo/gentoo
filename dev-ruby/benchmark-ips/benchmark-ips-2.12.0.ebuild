# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="History.md README.md"
RUBY_FAKEGEM_GEMSPEC="benchmark-ips.gemspec"

inherit ruby-fakegem

DESCRIPTION="A iterations per second enhancement to Benchmark"
HOMEPAGE="https://github.com/evanphx/benchmark-ips"
SRC_URI="https://github.com/evanphx/benchmark-ips/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/minitest-5.6:5 )"

all_ruby_prepare() {
	sed -i -e '1i require "tempfile"' test/test_benchmark_ips.rb || die
	sed -i -e 's/git ls-files --/find/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="power_assert.gemspec"

inherit ruby-fakegem

DESCRIPTION="Shows each value of variables and method calls in the expression"
HOMEPAGE="https://github.com/ruby/power_assert"
SRC_URI="https://github.com/ruby/power_assert/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( Ruby BSD-2 )"

SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile test/test_helper.rb || die
	sed -i -e '1igem "test-unit"' \
		-e '/byebug/ s:^:#:' test/test_helper.rb || die

	# Avoid git dependency
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid circular dependency on pry when bootstrapping ruby
	sed -i -e '/pry/ s:^:#:' -e '/test_colorized_pp/,/^    end/ s:^:#:' test/block_test.rb || die
}

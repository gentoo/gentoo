# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="The CSV library provides a complete interface to CSV files and data"
HOMEPAGE="https://github.com/ruby/csv"
SRC_URI="https://github.com/ruby/csv/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="$(ver_cut 1)"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-3.4.8 )"

all_ruby_prepare() {
	sed -i -e 's:require_relative ":require "./:' -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} run-test.rb || die
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="An XML toolkit for Ruby"
HOMEPAGE="https://github.com/ruby/rexml"
SRC_URI="https://github.com/ruby/rexml/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="3"

all_ruby_prepare() {
	sed -i -e 's:require_relative ":require "./:' -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}

each_ruby_test() {
	${RUBY} test/run.rb || die
}

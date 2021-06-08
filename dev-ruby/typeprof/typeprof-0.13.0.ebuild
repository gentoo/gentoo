# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_GEMSPEC="typeprof.gemspec"

inherit ruby-fakegem

DESCRIPTION="Performs a type analysis of non-annotated Ruby code"
HOMEPAGE="https://github.com/ruby/typeprof"
SRC_URI="https://github.com/ruby/typeprof/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/rbs-1.0.0"

all_ruby_prepare() {
	# Avoid tests that download live code using git
	rm -r test/typeprof/{goodcheck,diff-lcs}_test.rb || die

	sed -i -e "s:_relative ': './:" -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

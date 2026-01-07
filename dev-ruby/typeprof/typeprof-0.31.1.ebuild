# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_EXTRAINSTALL="sig"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_GEMSPEC="typeprof.gemspec"

inherit ruby-fakegem

DESCRIPTION="Performs a type analysis of non-annotated Ruby code"
HOMEPAGE="https://github.com/ruby/typeprof"
SRC_URI="https://github.com/ruby/typeprof/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

ruby_add_rdepend "
	>=dev-ruby/prism-1.4.0
	>=dev-ruby/rbs-3.6.0
"

all_ruby_prepare() {
	sed -e "s:_relative ': './:" \
		-e 's/git ls-files -z/find * -print0/' \
		-e '/ruby_version/ s/3.3/3.2/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

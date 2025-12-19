# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="repl_type_completor.gemspec"

inherit ruby-fakegem

DESCRIPTION="Type based completion for REPL"
HOMEPAGE="https://github.com/ruby/repl_type_completor"
SRC_URI="https://github.com/ruby/repl_type_completor/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"

IUSE="test"

ruby_add_rdepend "
	dev-ruby/prism:1
	<dev-ruby/rbs-4
"

ruby_add_bdepend "test? ( >=dev-ruby/irb-1.10.0 =dev-ruby/rake-13* dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e 's/__dir__/"."/' \
		-e 's:_relative ": "./:' \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

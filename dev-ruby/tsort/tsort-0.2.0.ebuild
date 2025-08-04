# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="tsort.gemspec"

inherit ruby-fakegem

DESCRIPTION="Topological sorting using Tarjan's algorithm"
HOMEPAGE="https://github.com/ruby/tsort"
SRC_URI="https://github.com/ruby/tsort/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_depend "test? ( dev-ruby/bundler dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -e 's/__FILE__/"ostruct.gemspec"/' \
		-e 's/__dir__/"."/' \
		-e "/spec.version/ s/= version/= '${PV}'/" \
		-e 's/git ls-files -z/find * -print0/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

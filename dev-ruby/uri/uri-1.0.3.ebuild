# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="uri.gemspec"

inherit ruby-fakegem

DESCRIPTION="URI is a module providing classes to handle Uniform Resource Identifiers"
HOMEPAGE="https://github.com/ruby/uri"
SRC_URI="https://github.com/ruby/uri/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

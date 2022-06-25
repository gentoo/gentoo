# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="net-telnet.gemspec"

# Don't install the binaries since they don't seem to be intended for
# general use and they have very generic names leading to collisions,
# e.g. bug 571186
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Provides telnet client functionality"
HOMEPAGE="https://github.com/ruby/net-telnet"
SRC_URI="https://github.com/ruby/net-telnet/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
SLOT="1"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

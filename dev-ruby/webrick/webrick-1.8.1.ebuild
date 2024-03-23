# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="webrick.gemspec"

inherit ruby-fakegem

DESCRIPTION="An HTTP server toolkit"
HOMEPAGE="https://github.com/ruby/webrick"
SRC_URI="https://github.com/ruby/webrick/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Ruby-BSD BSD-2 )"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE="test"

all_ruby_prepare() {
	sed -i -e "s:_relative ': './:" ${RUBY_FAKEGEM_GEMSPEC} || die

	# Increase timeout for test to help out slow arches
	sed -i -e '/EnvUtil.timeout(10) do/s:10:60:' test/webrick/test_ssl_server.rb || die
}

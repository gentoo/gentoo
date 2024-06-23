# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="mutex_m.gemspec"

inherit ruby-fakegem

DESCRIPTION="Mixin to extend objects to be handled like a Mutex"
HOMEPAGE="https://github.com/ruby/mutex_m"
SRC_URI="https://github.com/ruby/mutex_m/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE=""

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

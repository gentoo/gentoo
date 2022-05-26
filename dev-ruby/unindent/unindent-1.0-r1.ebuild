# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby method to unindent strings"
HOMEPAGE="https://github.com/mynyml/unindent"
LICENSE="MIT"

KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nanotest )"

each_ruby_test() {
	${RUBY} -I.:lib test/test_unindent.rb || die
}

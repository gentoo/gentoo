# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Extremely mynymal test framework"
HOMEPAGE="https://github.com/mynyml/nanotest"
LICENSE="MIT"

KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_prepare() {
	sed -e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/test_helper.rb test/test_nanotest.rb || die
}

each_ruby_test() {
	${RUBY} -I.:lib test/test_nanotest.rb || die
}

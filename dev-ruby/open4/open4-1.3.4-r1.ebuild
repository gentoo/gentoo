# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Open3::popen3 with exit status"
HOMEPAGE="https://github.com/ahoward/open4"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	mv rakefile Rakefile || die

	# Fix minitest deprecation
	sed -e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/lib/test_case.rb || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}

each_ruby_test() {
	${RUBY} -Ilib -Itest/lib test/*.rb || die
}

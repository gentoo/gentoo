# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem
DESCRIPTION="Manage class instances with dictionary"
HOMEPAGE="https://rubygems.org/gems/instance_storage/"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~riscv ~x86"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile test/instance_storage_test.rb || die

	sed -e 's/MiniTest::Unit::TestCase/Minitest::Test/' \
		-i test/instance_storage_test.rb || die
}

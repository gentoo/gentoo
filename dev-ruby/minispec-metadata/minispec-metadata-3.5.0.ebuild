# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Define and access metadata in MiniTest::Spec descriptions and specs"
HOMEPAGE="https://github.com/ordinaryzelig/minispec-metadata"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

ruby_add_rdepend "dev-ruby/minitest:5"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|awesome_print\)/ s:^:#:' Rakefile spec/helper.rb || die

	sed -e '1igem "minitest", "~> 5.0"' \
		-i spec/helper.rb || die
}

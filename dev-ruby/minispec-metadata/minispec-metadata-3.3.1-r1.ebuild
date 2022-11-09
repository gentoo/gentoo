# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Define and access metadata in MiniTest::Spec descriptions and specs"
HOMEPAGE="https://github.com/ordinaryzelig/minispec-metadata"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

ruby_add_rdepend "dev-ruby/minitest"

all_ruby_prepare() {
	sed -i -e '/\(bundler\|awesome_print\)/ s:^:#:' Rakefile spec/helper.rb || die
}

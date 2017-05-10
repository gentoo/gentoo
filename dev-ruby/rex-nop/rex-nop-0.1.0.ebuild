# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby21 ruby22 ruby23"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Rex library for dynamic generation of x86 multi-byte NOPs"
HOMEPAGE="https://rubygems.org/gems/rex-nop"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
RESTRICT="test"

ruby_add_rdepend "dev-ruby/rex-arch"

all_ruby_prepare() {
	sed -i '/bundler/d' Rakefile
}

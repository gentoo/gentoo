# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Core libraries required for the Ruby Exploitation(Rex) Suite"
HOMEPAGE="https://rubygems.org/gems/rex-core"

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

all_ruby_prepare() {
	sed -i '/bundler/d' Rakefile
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem
DESCRIPTION="ActiveSupport::Memoizable with a few enhancements"
HOMEPAGE="https://github.com/matthewrudy/memoist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple mime type detection using magic numbers, filenames, and extensions"
HOMEPAGE="https://github.com/basecamp/marcel"
SRC_URI="https://github.com/basecamp/marcel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/rack )"

all_ruby_prepare() {
	sed -i -e '2irequire "pathname"' -e '/byebug/ s:^:#:' test/test_helper.rb || die

	sed -i -e '/bundler/ s:^:#:' Rakefile || die
}

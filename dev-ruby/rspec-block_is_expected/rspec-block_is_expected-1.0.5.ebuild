# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="rspec-block_is_expected.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Simplify testing of blocks in RSpec"
HOMEPAGE="https://github.com/pboling/rspec-block_is_expected"
SRC_URI="https://github.com/pboling/rspec-block_is_expected/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE=""
SLOT="1"

LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~x86"

ruby_add_depend "test? ( >=dev-ruby/rspec-pending_for-0.1:0 )"

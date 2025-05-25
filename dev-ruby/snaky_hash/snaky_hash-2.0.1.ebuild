# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="snaky_hash.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A Hashie::Mash joint to make #snakelife better"
HOMEPAGE="https://gitlab.com/oauth-xx/snaky_hash"
SRC_URI="https://gitlab.com/oauth-xx/snaky_hash/-/archive/v${PV}/snaky_hash-v${PV}.tar.bz2 -> ${P}.tar.bz2"
RUBY_S="snaky_hash-v${PV}"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/hashie:*
	>=dev-ruby/version_gem-1.1.1:1
"

ruby_add_depend "test? ( dev-ruby/rspec-block_is_expected )"

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e 's/if RUN_COVERAGE/if false/' spec/spec_helper.rb || die
}

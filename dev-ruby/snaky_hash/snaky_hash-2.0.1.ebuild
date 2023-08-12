# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="snaky_hash.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A Hashie::Mash joint to make #snakelife better"
HOMEPAGE="https://gitlab.com/oauth-xx/snaky_hash"
SRC_URI="https://gitlab.com/oauth-xx/snaky_hash/-/archive/v${PV}/snaky_hash-v${PV}.tar.bz2 -> ${P}.tar.bz2"
RUBY_S="snaky_hash-v${PV}"
IUSE=""
SLOT="1"

LICENSE="MIT"
KEYWORDS="~amd64 ~riscv"

ruby_add_rdepend "
	dev-ruby/hashie:*
	>=dev-ruby/version_gem-1.1.1:1
"

ruby_add_depend "test? ( dev-ruby/rspec-block_is_expected )"

all_ruby_prepare() {
	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e 's/if RUN_COVERAGE/if false/' spec/spec_helper.rb || die
}

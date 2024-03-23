# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="version_gem.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

#RUBY_FAKEGEM_GEMSPEC="oauth.gemspec"

inherit ruby-fakegem

DESCRIPTION="Enhance that VERSION! Sugar for boring Version modules"
HOMEPAGE="https://gitlab.com/oauth-xx/version_gem"
SRC_URI="https://gitlab.com/oauth-xx/version_gem/-/archive/v${PV}/version_gem-v${PV}.tar.bz2 -> ${P}.tar.bz2"
RUBY_S="version_gem-v${PV}"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/rspec-block_is_expected )"

all_ruby_prepare() {
	sed -i -e 's/if RUN_COVERAGE/if false/' spec/spec_helper.rb || die

	# Avoid broken implementation already fixed upstream
	sed -i -e "s/'when actual' do/'when actual', pending: 'broken spec' do/" spec/version_gem/ruby_spec.rb || die
}

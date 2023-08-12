# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="rspec-stubbed_env.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="Stub environment variables in a scoped context for testing"
HOMEPAGE="https://github.com/pboling/rspec-stubbed_env"
SRC_URI="https://github.com/pboling/rspec-stubbed_env/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE=""
SLOT="1"

LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

ruby_add_rdepend ">=dev-ruby/rspec-3.0"

ruby_add_bdepend "test? ( dev-ruby/rspec-block_is_expected )"

all_ruby_prepare() {
	sed -i -e '/simplecov/ s:^:#:' spec/spec_helper.rb || die
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="globalid.gemspec"

inherit ruby-fakegem

DESCRIPTION="Reference models by URI"
HOMEPAGE="https://github.com/rails/globalid"
SRC_URI="https://github.com/rails/globalid/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

PATCHES=( "${FILESDIR}/${P}-ruby34.patch" )

ruby_add_bdepend "test? (
	dev-ruby/bundler
	<dev-ruby/activemodel-8.1
	<dev-ruby/railties-8.1
)"
ruby_add_rdepend ">=dev-ruby/activesupport-6.1:*"

all_ruby_prepare() {
	rm -f Gemfile.lock || die

	# Ensure a version of rails compatible with the tests.
	sed -e '/^gem / s/$/, "<8.1"/' \
		-i Gemfile || die

	# Avoid the assumption that the cache format matches the rails version.
	sed -e '/cache_format/ s/Rails::VERSION::STRING.to_f/7.1/' \
		-i test/cases/railtie_test.rb || die

	# Work around a bug in Rails: https://github.com/rails/rails/pull/55227
	sed -e '3irequire "action_controller"' \
		-i test/cases/railtie_test.rb || die
}

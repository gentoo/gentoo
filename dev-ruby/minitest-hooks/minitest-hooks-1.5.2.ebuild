# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_GEMSPEC="minitest-hooks.gemspec"

inherit ruby-fakegem

DESCRIPTION="Adds around and before_all/after_all/around_all hooks for Minitest"
HOMEPAGE="https://github.com/jeremyevans/minitest-hooks"
SRC_URI="https://github.com/jeremyevans/minitest-hooks/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~alpha ~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/minitest-5.3"

ruby_add_depend "test? ( >dev-ruby/sequel-4 dev-ruby/sqlite3  dev-ruby/minitest-global_expectations )"

each_ruby_test() {
	${RUBY} spec/all.rb || die
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Sprockets implementation for Rails 4.x (and beyond) Asset Pipeline"
HOMEPAGE="https://github.com/rails/sprockets-rails"
SRC_URI="https://github.com/rails/sprockets-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux"

IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/actionpack-5.2:*
	>=dev-ruby/activesupport-5.2:*
	>=dev-ruby/sprockets-3.0.0:*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/railties-5.2:*
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	# It looks like tests are order dependent
	sed -i -e '/test_order/ s/:alpha/:random/' test/test_helper.rb || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Sprockets implementation for Rails 4.x (and beyond) Asset Pipeline"
HOMEPAGE="https://github.com/rails/sprockets-rails"
SRC_URI="https://github.com/rails/sprockets-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"

IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/actionpack-5.2:*
	>=dev-ruby/activesupport-5.2:*
	>=dev-ruby/sprockets-3.0.0:*"

ruby_add_bdepend "
	test? (
		<dev-ruby/railties-6.1
		dev-ruby/test-unit:2
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' Rakefile || die

	# Help load correct rack version consistently
	sed -i -e "1igem 'railties', '< 6.1'" test/test_helper.rb || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Official Ruby-on-Rails Integration with Sass"
HOMEPAGE="https://github.com/rails/sass-rails"
SRC_URI="https://github.com/rails/sass-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux"

IUSE=""

# Restrict tests for now since it is hard to set up the right
# environment with the correct ruby interpreter and Rails test
# application.
RESTRICT="test"

#ruby_add_bdepend "test? ( dev-ruby/sfl dev-ruby/bundler )"

ruby_add_rdepend ">=dev-ruby/sass-3.1:* =dev-ruby/sass-3*:*
	>=dev-ruby/railties-5.2.0
	>=dev-ruby/sprockets-rails-2.0:* <dev-ruby/sprockets-rails-4:*
	>=dev-ruby/sprockets-2.8:* <dev-ruby/sprockets-4:*
	>=dev-ruby/tilt-1.1:* <dev-ruby/tilt-3:*"

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem versionator

DESCRIPTION="Official Ruby-on-Rails Integration with Sass"
HOMEPAGE="https://github.com/rails/sass-rails"
SRC_URI="https://github.com/rails/sass-rails/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""

# Restrict tests for now since it is hard to set up the right
# environment with the correct ruby interpreter and Rails test
# application.
RESTRICT="test"

#ruby_add_bdepend "test? ( dev-ruby/sfl dev-ruby/bundler )"

ruby_add_rdepend ">=dev-ruby/sass-3.1 =dev-ruby/sass-3*
	=dev-ruby/railties-4*
	>=dev-ruby/sprockets-rails-2.0 <dev-ruby/sprockets-rails-4
	>=dev-ruby/sprockets-2.8 <dev-ruby/sprockets-4
	>=dev-ruby/tilt-1.1 =dev-ruby/tilt-1*"

each_ruby_test() {
	${RUBY} -S bundle exec rake test || die
}

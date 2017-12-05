# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="Library to start and stop specific daemons programmatically in a robust manner"
HOMEPAGE="https://github.com/FooBarWidget/daemon_controller"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

all_ruby_prepare() {
	# fix tests with RSpec 2
	sed -i -e '1irequire "thread"' spec/test_helper.rb || die
}

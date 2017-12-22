# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST="test"

inherit ruby-fakegem

DESCRIPTION="Backports of Ruby features for older Ruby"
HOMEPAGE="https://github.com/marcandre/backports"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc"
IUSE=""

all_ruby_prepare() {
	# Avoid activesupport test that no longer works in Rails 5. This also avoids
	# a dependency on activesupport
	sed -i -e '/test_rails/,/^  end/ s:^:#:' test/_backport_guards_test.rb || die
}

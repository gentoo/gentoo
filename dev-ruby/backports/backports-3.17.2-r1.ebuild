# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_GEMSPEC="backports.gemspec"

inherit ruby-fakegem

DESCRIPTION="Backports of Ruby features for older Ruby"
HOMEPAGE="https://github.com/marcandre/backports"
SRC_URI="https://github.com/marcandre/backports/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

all_ruby_prepare() {
	# Avoid activesupport test that no longer works in Rails 5. This also avoids
	# a dependency on activesupport
	sed -i -e '/test_rails/,/^  end/ s:^:#:' test/_backport_guards_test.rb || die

	sed -i -e '/rubocop/I s:^:#:' Rakefile || die
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_TASK_TEST="test"

inherit ruby-fakegem

DESCRIPTION="Backports of Ruby features for older Ruby"
HOMEPAGE="https://github.com/marcandre/backports"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 s390 sparc x86"
IUSE=""

all_ruby_prepare() {
	# Avoid activesupport test that no longer works in Rails 5. This also avoids
	# a dependency on activesupport
	sed -i -e '/test_rails/,/^  end/ s:^:#:' test/_backport_guards_test.rb || die
}

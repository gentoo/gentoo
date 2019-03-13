# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
inherit ruby-fakegem

DESCRIPTION="Ruby implementation of the GNU readline C library forked by r7"
HOMEPAGE="https://rubygems.org/gems/rb-readline-r7"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
DEPEND="test? ( dev-ruby/minitest
		dev-ruby/rake )"

all_ruby_prepare() {
	# Skip a test that fails when run in the ebuild environment.
	sed -i -e '/test_readline_with_default_parameters_does_not_error/,/end/ s:^:#:' test/test_readline.rb || die
}

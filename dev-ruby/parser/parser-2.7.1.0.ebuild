# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_VERSION="${PV/_pre/.pre.}"

inherit ruby-fakegem

DESCRIPTION="A production-ready Ruby parser written in pure Ruby"
HOMEPAGE="https://github.com/whitequark/parser"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/minitest:5
	dev-ruby/racc
	dev-ruby/cliver )"
ruby_add_rdepend "=dev-ruby/ast-2.4*"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e '/simplecov/ s:^:#:' test/helper.rb || die
}

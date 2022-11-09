# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_TASK_TEST="test"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_VERSION="${PV/_pre/.pre.}"

RUBY_FAKEGEM_GEMSPEC="parser.gemspec"

inherit ruby-fakegem

DESCRIPTION="A production-ready Ruby parser written in pure Ruby"
HOMEPAGE="https://github.com/whitequark/parser"
SRC_URI="https://github.com/whitequark/parser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~sparc"
IUSE=""

DEPEND+=" =dev-util/ragel-6*"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
		dev-ruby/racc )
	dev-ruby/cliver
"
ruby_add_rdepend "=dev-ruby/ast-2.4* >=dev-ruby/ast-2.4.1"

all_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e '/simplecov/ s:^:#:' test/helper.rb || die
}

each_ruby_compile() {
	${RUBY} -S rake generate || die
}

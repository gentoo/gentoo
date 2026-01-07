# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="tomlrb.gemspec"

TOML_TEST_COMMIT=2849ded9b2254658f1b090d76e653cb827441691

inherit ruby-fakegem

DESCRIPTION="A racc based toml parser"
HOMEPAGE="https://github.com/fbernier/tomlrb/"
SRC_URI="https://github.com/fbernier/tomlrb/archive/v${PV}.tar.gz -> ${P}.tar.gz
		 test? ( https://github.com/toml-lang/toml-test/archive/${TOML_TEST_COMMIT}.tar.gz -> ${P}-toml-test.tar.gz )"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "dev-ruby/racc test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	if use test ; then
		rm -rf toml-test || die
		mv ../toml-test-* toml-test || die
	fi

	sed -i -e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/reporters/I s:^:#:' test/minitest_helper.rb || die
}

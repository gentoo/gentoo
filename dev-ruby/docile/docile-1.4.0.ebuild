# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="README.md HISTORY.md"

RUBY_FAKEGEM_GEMSPEC="docile.gemspec"

inherit ruby-fakegem

DESCRIPTION="Turns any Ruby object into a DSL"
HOMEPAGE="https://ms-ati.github.io/docile/"
SRC_URI="https://github.com/ms-ati/docile/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE=""

all_ruby_prepare() {
	sed -i -e '/require \"github\/markup\"/d' Rakefile || die
	sed -i -e '/simplecov/,/unshift/ s:^:#:' spec/spec_helper.rb || die

	sed -i -e 's:_relative ": "./:' -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

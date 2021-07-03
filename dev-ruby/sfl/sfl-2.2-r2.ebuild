# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="Library providing spawn() which is almost perfectly compatible with ruby 1.9's"
HOMEPAGE="https://github.com/ujihisa/spawn-for-legacy"

LICENSE="|| ( Ruby BSD-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE=""

all_ruby_prepare() {
	rm -f Gemfile* || die
	sed -i -e "s:/tmp:${TMPDIR}:" spec/sfl_spec.rb || die
}

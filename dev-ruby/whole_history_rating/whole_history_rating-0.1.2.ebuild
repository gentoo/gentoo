# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A pure ruby implementation of Remi Coulom's Whole-History Rating algorithm"
HOMEPAGE="https://github.com/goshrine/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

ruby_add_bdepend "
	test? (
		dev-ruby/test-unit:2
	)
"

all_ruby_prepare (){
	sed -i 's/git ls-files/ls -1/g' "${RUBY_FAKEGEM_GEMSPEC}" || die
	default
}

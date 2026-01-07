# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rake"
RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.creole"

RUBY_FAKEGEM_GEMSPEC="creole.gemspec"

inherit ruby-fakegem

DESCRIPTION="Creole-to-HTML converter for Creole, the lightweight markup language"
HOMEPAGE="https://github.com/minad/creole"
SRC_URI="https://github.com/minad/creole/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/bacon )"

all_ruby_prepare() {
	sed -e 's/git ls-files --/echo/' \
		-e 's/git ls-files/find -print/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

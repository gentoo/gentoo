# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_EXTRADOC="History.rdoc README.md Todo.rdoc"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Simple, feature rich ascii table generation library"
HOMEPAGE="https://github.com/tj/terminal-table"
SRC_URI="https://github.com/tj/terminal-table/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"

ruby_add_rdepend "|| ( dev-ruby/unicode-display_width:2 >=dev-ruby/unicode-display_width-1.1.1:1 )"

ruby_add_bdepend "test? ( dev-ruby/term-ansicolor )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

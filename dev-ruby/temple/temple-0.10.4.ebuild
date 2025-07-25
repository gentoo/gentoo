# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_EXTRADOC="CHANGES EXPRESSIONS.md README.md"
RUBY_FAKEGEM_GEMSPEC="temple.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="An abstraction and a framework for compiling templates to pure Ruby"
HOMEPAGE="https://github.com/judofyr/temple"
SRC_URI="https://github.com/judofyr/temple/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0.7"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"

ruby_add_bdepend "test? (
	dev-ruby/erubi
	>=dev-ruby/tilt-2.0.1 )"

all_ruby_prepare() {
	sed -e 's/__FILE__/"."/' \
		-e 's/git ls-files -z/find * -print0/' \
		-e 's/git ls-files --/echo/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

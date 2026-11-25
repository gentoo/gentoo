# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="lumberjack.gemspec"

inherit ruby-fakegem

DESCRIPTION="A simple, powerful, and very fast logging utility"
HOMEPAGE="https://github.com/bdurand/lumberjack"
SRC_URI="https://github.com/bdurand/lumberjack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend "dev-ruby/logger"

ruby_add_bdepend "test? ( >=dev-ruby/timecop-0.8 )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' -e 's/__dir__/"."/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

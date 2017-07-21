# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="constraint based package dependency resolver"
HOMEPAGE="https://github.com/opscode/dep-selector"
SRC_URI="https://github.com/opscode/dep-selector/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RUBY_S=${P/_/-}

DEPEND+=" >=dev-libs/gecode-3.5.0 <dev-libs/gecode-4"
RDEPEND+=" >=dev-libs/gecode-3.5.0 <dev-libs/gecode-4"

ruby_add_rdepend ">=dev-ruby/ffi-1.9"

all_ruby_prepare() {
	# Avoid dependency on vendored libgecode and use system version instead
	sed -i -e '27,46 s:^:#:' ext/dep_gecode/extconf.rb || die
	sed -i -e '/dep-selector-libgecode/d' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid integration tests for unpackaged solve
	rm spec/solve_integration_spec.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/dep_gecode extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/dep_gecode CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" V=1
	cp ext/dep_gecode/dep_gecode$(get_modname) lib/ || die
}

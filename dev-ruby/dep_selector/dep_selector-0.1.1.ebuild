# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit ruby-fakegem

DESCRIPTION="constraint based package dependency resolver"
HOMEPAGE="https://github.com/opscode/dep-selector"
SRC_URI="https://github.com/opscode/dep-selector/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RUBY_S=${P/_/-}

DEPEND+=" >=dev-libs/gecode-3.5.0"
RDEPEND+=" >=dev-libs/gecode-3.5.0"

ruby_add_rdepend "dev-ruby/uuidtools"

each_ruby_configure() {
	${RUBY} -Cext/dep_gecode extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake -Cext/dep_gecode CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" V=1
	cp ext/dep_gecode/dep_gecode$(get_modname) lib/ || die
	cp ext/dep_gecode/lib/dep_selector_to_gecode.rb lib/ || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rb-gsl/rb-gsl-1.16.0.3.ebuild,v 1.1 2014/10/22 13:02:47 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

inherit ruby-fakegem multilib

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README"

RUBY_FAKEGEM_TASK_TEST="test:libs"
DESCRIPTION="Ruby interface to GNU Scientific Library"
HOMEPAGE="https://github.com/david-macmahon/rb-gsl"
#SRC_URI="https://github.com/david-macmahon/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND+=" sci-libs/gsl"
RDEPEND+=" sci-libs/gsl"

RUBY_S="${PN}-${P}"

ruby_add_rdepend "dev-ruby/narray"

each_ruby_prepare() {
	sed -i -e '/$CPPFLAGS =/a \$LDFLAGS = " -L#{narray_config} -l:narray.so "+$LDFLAGS' -e 's/src/lib/' ext/gsl/extconf.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/gsl extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/gsl V=1
	cp ext/gsl/*$(get_modname) lib/gsl || die
}

each_ruby_test() {
	${RUBY} -S testrb -Ilib -Itest test/*.rb test/*/*.rb || die
}

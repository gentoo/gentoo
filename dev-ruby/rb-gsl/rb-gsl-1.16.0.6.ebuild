# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rb-gsl/rb-gsl-1.16.0.6.ebuild,v 1.1 2015/07/04 08:43:55 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_NAME="gsl"
inherit ruby-fakegem multilib

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md"

RUBY_FAKEGEM_TASK_TEST="test:libs"
DESCRIPTION="Ruby interface to GNU Scientific Library"
HOMEPAGE="https://github.com/SciRuby/rb-gsl"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND+=" >=sci-libs/gsl-1.15"
RDEPEND+=" >=sci-libs/gsl-1.15"

RUBY_S="${PN}-${P}"

ruby_add_bdepend "dev-ruby/narray"
ruby_add_rdepend "dev-ruby/narray"

each_ruby_prepare() {
	sed -i -e '/$CPPFLAGS =/a \$LDFLAGS = " -L#{narray_config} -l:narray.so "+$LDFLAGS' -e 's/src/lib/' ext/gsl_native/extconf.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext/gsl_native extconf.rb || die
}

each_ruby_compile() {
	emake -Cext/gsl_native V=1
	cp ext/gsl_native/*$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/*_test.rb"].each{|f| require f}' || die
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_NAME="ferret"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_FAKEGEM_DOCDIR="doc/api"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG RELEASE_CHANGES RELEASE_NOTES README TODO TUTORIAL"

inherit multilib ruby-fakegem

MY_P="${P/ruby-/}"
DESCRIPTION="A ruby indexing/searching library"
HOMEPAGE="http://ferret.davebalmain.com/trac/"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND+=" app-arch/bzip2"
DEPEND+=" app-arch/bzip2"

all_ruby_prepare() {
	# Remove bundled bzlib code and use system version instead.
	rm ext/BZLIB* ext/bzlib* || die
	sed -i -e '14i  $LDFLAGS += " -lbz2 "' ext/extconf.rb || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

each_ruby_compile() {
	emake -Cext CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}" V=1
	cp ext/ferret_ext$(get_modname) lib/ || die
}

each_ruby_test() {
	${RUBY} -Ilib test/test_all.rb || die
}

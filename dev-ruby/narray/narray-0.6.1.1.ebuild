# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# jruby → native extension
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md README.ja.md SPEC.en.txt SPEC.ja.txt"

RUBY_FAKEGEM_VERSION="${PV/_p/.}"

inherit multilib ruby-fakegem

DESCRIPTION="Numerical N-dimensional Array class"
HOMEPAGE="http://www.ir.isas.ac.jp/~masa/ruby/index-e.html"
SRC_URI="https://github.com/masa16/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc ~ppc64 x86"

IUSE=""

all_ruby_prepare() {
	# the tests aren't really written to be a testsuite, so the
	# failure cases will literally fail; ignore all of those and
	# instead expect that the rest won't fail.
	sed -i -e '/[fF]ollowing will fail/,$ s:^:#:' \
		-e '/next will fail/,$ s:^:#:' \
		test/*.rb || die "sed failed"
}

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake V=1 CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
	cp -l ${PN}$(get_modname) ${PN}.h ${PN}_config.h lib/ || die "copy of ${PN}$(get_modname) failed"
}

each_ruby_test() {
	for unit in test/*; do
		${RUBY} -Ilib ${unit} || die "test ${unit} failed"
	done
}

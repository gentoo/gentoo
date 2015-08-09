# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# jruby → native extension
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.en README.ja SPEC.en SPEC.ja"

RUBY_FAKEGEM_VERSION="${PV/_p/.}"

inherit multilib ruby-fakegem

DESCRIPTION="Numerical N-dimensional Array class"
HOMEPAGE="http://www.ir.isas.ac.jp/~masa/ruby/index-e.html"
SRC_URI="https://github.com/masa16/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 hppa ~mips ppc ~ppc64 x86"

IUSE=""

RUBY_PATCHES=( "${FILESDIR}"/${P}-fix-tests.patch )

all_ruby_prepare() {
	# the tests aren't really written to be a testsuite, so the
	# failure cases will literally fail; ignore all of those ad
	# instead expect that the rest won't fail.
	sed -i -e '/[fF]ollowing will fail/,$ s:^:#:' \
		-e '/next will fail/,$ s:^:#:' \
		test/*.rb || die "sed failed"
}

each_ruby_configure() {
	${RUBY} extconf.rb || die "extconf.rb failed"
}

each_ruby_compile() {
	emake CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
	cp -l ${PN}$(get_modname) ${PN}.h ${PN}_config.h lib/ || die "copy of ${PN}$(get_modname) failed"
}

each_ruby_test() {
	for unit in test/*; do
		# Skip over the FFTW test because it needs a package we don't
		# have in tree.
		[[ ${unit} == test/testfftw.rb ]] && continue

		${RUBY} -Ilib ${unit} || die "test ${unit} failed"
	done
}

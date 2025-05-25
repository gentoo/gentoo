# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="ChangeLog README.md README.ja.md SPEC.en.txt SPEC.ja.txt"

RUBY_FAKEGEM_GEMSPEC="narray.gemspec"
RUBY_FAKEGEM_VERSION="${PV/_p/.}"

RUBY_FAKEGEM_EXTENSIONS=(./extconf.rb)

inherit flag-o-matic ruby-fakegem

DESCRIPTION="Numerical N-dimensional Array class"
HOMEPAGE="https://masa16.github.io/narray/"
SRC_URI="https://github.com/masa16/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~hppa ~mips ppc ~ppc64 x86"

all_ruby_prepare() {
	# the tests aren't really written to be a testsuite, so the
	# failure cases will literally fail; ignore all of those and
	# instead expect that the rest won't fail.
	sed -i -e '/[fF]ollowing will fail/,$ s:^:#:' \
		-e '/next will fail/,$ s:^:#:' \
		test/*.rb || die "sed failed"

	sed -i -e 's:src/narray.h:narray.h:' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/CFLAGS/ s/^#//' \
		-i extconf.rb || die
}

each_ruby_configure() {
	append-flags -std=gnu17
	filter-flags -std=gnu23

	each_fakegem_configure
}

each_ruby_test() {
	for unit in test/*; do
		${RUBY} -Ilib ${unit} || die "test ${unit} failed"
	done
}

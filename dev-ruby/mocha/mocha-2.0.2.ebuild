# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST="test:units test:acceptance"

RUBY_FAKEGEM_EXTRADOC="README.md RELEASE.md"

RUBY_FAKEGEM_GEMSPEC="mocha.gemspec"

inherit ruby-fakegem

DESCRIPTION="Mocking and stubbing using a syntax like that of JMock and SchMock"
HOMEPAGE="https://mocha.jamesmead.org/"
SRC_URI="https://github.com/freerange/mocha/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/ruby2_keywords-0.0.5"

ruby_add_bdepend "
	test? ( >=dev-ruby/test-unit-2.5.1-r1 dev-ruby/introspection )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.16.0-ruby32.patch
)

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '1iload "lib/mocha/version.rb"' Rakefile || die

	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	export MOCHA_NO_DOCS=true
	each_fakegem_test
}

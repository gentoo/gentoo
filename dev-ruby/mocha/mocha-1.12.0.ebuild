# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="test:units test:acceptance"

RUBY_FAKEGEM_EXTRADOC="README.md RELEASE.md"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

RUBY_FAKEGEM_GEMSPEC="mocha.gemspec"

inherit ruby-fakegem

DESCRIPTION="Mocking and stubbing using a syntax like that of JMock and SchMock"
HOMEPAGE="https://mocha.jamesmead.org/"
SRC_URI="https://github.com/freerange/mocha/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "
	test? ( >=dev-ruby/test-unit-2.5.1-r1 dev-ruby/introspection )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '1iload "lib/mocha/version.rb"' Rakefile || die

	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	export MOCHA_NO_DOCS=true
	each_fakegem_test
}

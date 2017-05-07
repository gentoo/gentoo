# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST="MOCHA_NO_DOCS=true test:units"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md RELEASE.md"

RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

inherit ruby-fakegem

DESCRIPTION="Mocking and stubbing using a syntax like that of JMock and SchMock"
HOMEPAGE="http://gofreerange.com/mocha/docs/"

LICENSE="MIT"
SLOT="0.14"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

ruby_add_bdepend "
	test? ( >=dev-ruby/test-unit-2.5.1-r1 dev-ruby/introspection )"

ruby_add_rdepend "dev-ruby/metaclass" #metaclass ~> 0.0.1

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '1iload "lib/mocha/version.rb"' Rakefile || die
	sed -i -e '20irequire "mocha/setup"' test/test_helper.rb || die
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="QED (Quality Ensured Demonstrations) is a TDD/BDD framework"
HOMEPAGE="https://rubyworks.github.io/qed/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/ae )"
ruby_add_rdepend "
	dev-ruby/ansi
	dev-ruby/brass"

each_ruby_test() {
	${RUBY} -Ilib bin/qed || die 'tests failed'
}

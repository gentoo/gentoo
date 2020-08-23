# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Lemon is a unit testing framework"
HOMEPAGE="https://rubyworks.github.io/lemon/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/qed )"
ruby_add_rdepend "
	dev-ruby/ae
	>=dev-ruby/ansi-1.3
	dev-ruby/rubytest"

each_ruby_test() {
	${RUBY} -S qed || die 'tests failed'
}

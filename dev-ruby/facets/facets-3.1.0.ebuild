# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Facets is the premier collection of extension methods for Ruby"
HOMEPAGE="https://rubyworks.github.io/facets/"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "test? (
	dev-ruby/ae
	dev-ruby/lemon
	dev-ruby/rubytest
	dev-ruby/rubytest-cli )"

all_ruby_prepare() {

	# Tests need to write to tmp/
	mkdir tmp/ || die 'mkdir failed'
}

each_ruby_test() {
	${RUBY} -S rubytest -r lemon -r ae -Ilib/core -Ilib/standard -Itest test/ || die 'tests failed'
}

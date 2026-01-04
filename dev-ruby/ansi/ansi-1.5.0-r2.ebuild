# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="DEMO.md HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="The Ruby ANSI project is collection of ANSI escape codes for Ruby"
HOMEPAGE="https://rubyworks.github.io/ansi/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

# Tests cause circular dependencies with dev-ruby/qed & dev-ruby/rubytest
RESTRICT="test"

each_ruby_test() {
	${RUBY} -S rubytest -Ilib -Itest test/ || die 'tests failed'
}

# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="The Hashery is a tight collection of Hash-like classes"
HOMEPAGE="https://rubyworks.github.io/hashery/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

ruby_add_bdepend "test? (
	dev-ruby/lemon
	dev-ruby/qed
	dev-ruby/rubytest
	dev-ruby/rubytest-cli )"

each_ruby_test() {
	${RUBY} -S qed || die 'tests failed'
	${RUBY} -S rubytest -Ilib -Itest test/ || die 'tests failed'
}

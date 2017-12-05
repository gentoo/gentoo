# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Ruby method to unindent strings"
HOMEPAGE="https://github.com/mynyml/unindent"
LICENSE="MIT"

KEYWORDS="~amd64 arm ~arm64 ~ia64 ppc ppc64 ~sparc ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/nanotest )"

each_ruby_test() {
	${RUBY} -I.:lib test/test_unindent.rb || die
}

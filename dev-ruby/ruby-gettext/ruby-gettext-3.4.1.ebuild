# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

RUBY_FAKEGEM_NAME="${PN/ruby-/}"
RUBY_FAKEGEM_VERSION="${PV%_*}"

RUBY_FAKEGEM_RECIPE_DOC="yard"
RUBY_FAKEGEM_EXTRADOC="README.md doc/text/news.md"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_EXTRAINSTALL="locale po"

inherit ruby-fakegem

DESCRIPTION="Native Language Support Library and Tools modeled after GNU gettext package"
HOMEPAGE="https://ruby-gettext.github.io/"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="doc test"
SLOT="0"
LICENSE="|| ( Ruby LGPL-3+ )"

ruby_add_rdepend ">=dev-ruby/locale-2.0.5 >=dev-ruby/text-1.3.0"

ruby_add_bdepend "doc? ( dev-ruby/yard )
	dev-ruby/racc"
ruby_add_bdepend "test? (
	dev-ruby/test-unit:2
	dev-ruby/test-unit-rr )"

RDEPEND+=" sys-devel/gettext"
DEPEND+=" sys-devel/gettext"

all_ruby_prepare() {
	# Fix broken racc invocation
	sed -i -e '/command_line/ s/#{racc}/-S racc/' Rakefile || die

	# Avoid bundler dependency
	sed -i -e '/bundler/,/helper.install/ s:^:#:' \
		-e 's/helper.gemspec/Gem::Specification.new/' Rakefile || die

	# Avoid dependency on developer-specific tools.
	sed -i -e '/notify/ s:^:#:' test/run-test.rb || die
}

each_ruby_test() {
	# Upstream tries to daisy-chain rake calls but they fail badly
	# with our setup, so run it manually.
	${RUBY} test/run-test.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}

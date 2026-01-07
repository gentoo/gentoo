# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="none"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="A wrapper library to bring Unicode Normalization Form support to Ruby/JRuby"
HOMEPAGE="https://github.com/knu/ruby-unf"
SRC_URI="https://github.com/knu/ruby-unf/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
RUBY_S="ruby-${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="test"

ruby_add_rdepend "dev-ruby/unf_ext"

ruby_add_bdepend "
	test? (
		>=dev-ruby/test-unit-2.5.1-r1
		dev-ruby/unf_ext
	)"

all_ruby_prepare() {
	sed -i -e '/bundler/,/end/ d' test/helper.rb || die

	# Remove development dependencies; also remove platform as we don't
	# care about it as it is, they only use it to avoid the unf_ext dep
	# that we tackle on our own; finally remove git ls-files usage.
	sed -i -e '/dependency.*\(shoulda\|bundler\|jeweler\|rcov\)/d' \
		-e '/platform/d' \
		-e '/gem.extensions/d' \
		-e '/git ls/d' \
		${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	ruby-ng_testrb-2 test/test_*.rb
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_RECIPE_DOC="yard"

RUBY_FAKEGEM_GEMSPEC="rouge.gemspec"

inherit ruby-fakegem

DESCRIPTION="Yet-another-markdown-parser using a strict syntax definition in pure Ruby"
HOMEPAGE="https://github.com/jneen/rouge"
SRC_URI="https://github.com/jneen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/redcarpet )
	test? ( dev-ruby/minitest-power_assert )
	dev-ruby/yard
"

ruby_add_rdepend "dev-ruby/redcarpet"

all_ruby_prepare() {
	rm -f tasks/{check/style,update/changelog}.rake || die

	sed -i -e '/bundler/I s:^:#: ; 5irequire "minitest-power_assert"' spec/spec_helper.rb || die
	sed -i -e '/\(changelog\|bundler\|rubocop\)/ s:^:#: ; 1irequire "pathname"' Rakefile || die
}

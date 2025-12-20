# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="oauth-tty.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="OAuth 1.0 TTY Command Line Interface"
HOMEPAGE="https://github.com/ruby-oauth/oauth-tty"
SRC_URI="https://github.com/ruby-oauth/oauth-tty/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
IUSE="test"

ruby_add_rdepend "
	>=dev-ruby/version_gem-1.1.1:1
	!<dev-ruby/oauth-0.6.2-r2:0
"

ruby_add_bdepend "test? (
	>=dev-ruby/minitest-5.15
	dev-ruby/mocha
	>=dev-ruby/oauth-1.1.0
	dev-ruby/rack-test
	dev-ruby/webmock
)"

all_ruby_prepare() {
	sed -e 's:_relative ": "./:' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -e '/kettle/ s:^:#:' \
		-e '/simplecov/ s:^:#:' \
		-i spec/spec_helper.rb || die
}

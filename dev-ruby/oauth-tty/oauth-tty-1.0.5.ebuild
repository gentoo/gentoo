# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32"

RUBY_FAKEGEM_BINDIR="exe"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="oauth-tty.gemspec"

inherit ruby-fakegem

DESCRIPTION="OAuth 1.0 TTY Command Line Interface"
HOMEPAGE="https://gitlab.com/oauth-xx/oauth-tty"
SRC_URI="https://gitlab.com/oauth-xx/oauth-tty/-/archive/v${PV}/oauth2-${PV}.tar.bz2"
RUBY_S="${PN}-v${PV}-*"

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
	# Avoid unneeded coverage tools
	sed -e 's/if RUN_COVERAGE/if false/' -i test/test_helper.rb || die

	# Fix deprecated minitest names
	sed -e 's/MiniTest/Minitest/' -i test/*_test.rb || die

	# # Avoid test tripped up by kwargs confusion
	sed -e '/test_authorize/askip "kwargs confusion"' \
		-i test/cli_test.rb || die

	sed -e 's:_relative ": "./:' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

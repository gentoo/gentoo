# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="airbrussh.gemspec"

inherit ruby-fakegem

DESCRIPTION="A replacement log formatter for SSHKit"
HOMEPAGE="https://github.com/mattbrictson/airbrussh"
SRC_URI="https://github.com/mattbrictson/airbrussh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">dev-ruby/sshkit-1.7.0"

ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find . -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	rm -f test/support/minitest_reporters.rb || die

	# Avoid a test poluting the environment
	sed -i -e '/test_color_is_can_be_forced_via_env/,/^  end/ s:^:#:' test/airbrussh/console_test.rb || die
}

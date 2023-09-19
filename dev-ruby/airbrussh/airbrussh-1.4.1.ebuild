# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_BINWRAP=""

RUBY_FAKEGEM_GEMSPEC="airbrussh.gemspec"

inherit ruby-fakegem

DESCRIPTION="A replacement log formatter for SSHKit"
HOMEPAGE="https://github.com/mattbrictson/airbrussh"
SRC_URI="https://github.com/mattbrictson/airbrussh/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE=""

ruby_add_rdepend ">dev-ruby/sshkit-1.7.0"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/mocha:1.0 )"

all_ruby_prepare() {
	sed -i -e 's/git ls-files -z/find * -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die

	sed -i -e '2igem "mocha", "~> 1.0"' test/minitest_helper.rb || die

	rm -f test/support/minitest_reporters.rb || die

	# Add missing require
	sed -i -e '1irequire "rake" ; require "rake/task"' test/support/rake_task_definition.rb || die

	# Avoid a test poluting the environment
	sed -i -e '/test_color_is_can_be_forced_via_env/,/^  end/ s:^:#:' test/airbrussh/console_test.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test:. -e 'Dir["test/**/*_test.rb"].each {|f| require f}' || die
}

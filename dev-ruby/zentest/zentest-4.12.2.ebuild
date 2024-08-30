# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_NAME=ZenTest

RUBY_FAKEGEM_EXTRADOC="README.txt History.txt example.txt example1.rb example2.rb"

inherit ruby-fakegem

DESCRIPTION="Testing tools: zentest, unit_diff, autotest, multiruby, and Test::Rails"
HOMEPAGE="https://github.com/seattlerb/zentest"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
	)"

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

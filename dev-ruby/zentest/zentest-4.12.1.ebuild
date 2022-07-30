# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_NAME=ZenTest

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt example.txt example1.rb example2.rb"

inherit ruby-fakegem

DESCRIPTION="Testing tools: zentest, unit_diff, autotest, multiruby, and Test::Rails"
HOMEPAGE="https://github.com/seattlerb/zentest"
LICENSE="MIT"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_bdepend "
	test? (
		dev-ruby/minitest:5
	)"

each_ruby_test() {
	MT_NO_PLUGINS=true ${RUBY} -Ilib:. -e 'Dir["test/test_*.rb"].each{|f| require f}' || die
}

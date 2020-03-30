# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_NAME=ZenTest

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt example.txt example1.rb example2.rb example_dot_autotest.rb"

inherit ruby-fakegem

DESCRIPTION="Testing tools: zentest, unit_diff, autotest, multiruby, and Test::Rails"
HOMEPAGE="https://github.com/seattlerb/zentest"
LICENSE="Ruby"

KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

ruby_add_bdepend "
	test? (
		>=dev-ruby/hoe-2.10
		dev-ruby/hoe-seattlerb
		dev-ruby/minitest:5
	)"

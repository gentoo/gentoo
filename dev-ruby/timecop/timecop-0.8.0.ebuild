# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/timecop/timecop-0.8.0.ebuild,v 1.2 2015/08/06 22:09:06 mrueg Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A gem providing 'time travel' and 'time freezing' capabilities"
HOMEPAGE="https://github.com/jtrupiano/timecop"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""

# Missing testdep activesupport
ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' -e '/History.rdoc/d' Rakefile test/test_helper.rb || die
	sed -i -e '/rubygems/ a\gem "test-unit"' test/test_helper.rb || die
	# FIXME after activesupport gained ruby22 support
	rm test/time_stack_item_test.rb || die
}

each_ruby_prepare() {
	sed -i -e "/bin\/sh/ a\RUBY='${RUBY}'" test/run_tests.sh || die
}

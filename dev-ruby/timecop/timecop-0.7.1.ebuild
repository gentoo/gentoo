# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC="rdoc"
RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.markdown"

inherit ruby-fakegem

DESCRIPTION="A gem providing 'time travel' and 'time freezing' capabilities"
HOMEPAGE="https://github.com/travisjeffery/timecop"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86 ~x86-fbsd"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/mocha )"

all_ruby_prepare() {
	sed -i -e '/bundler/ s:^:#:' -e '/History.rdoc/d' Rakefile test/test_helper.rb || die
	sed -i -e '/rubygems/ a\gem "test-unit"' test/test_helper.rb || die
}
each_ruby_prepare() {
	sed -i -e "/bin\/sh/ a\RUBY='${RUBY}'" test/run_tests.sh || die
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES.md README.md"

RUBY_FAKEGEM_GEMSPEC=rr.gemspec

inherit ruby-fakegem

DESCRIPTION="A double framework featuring a selection of double techniques and a terse syntax"
HOMEPAGE="https://rr.github.io/rr"
SRC_URI="https://github.com/rr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? (
		dev-ruby/rspec:2
		dev-ruby/minitest
		dev-ruby/diff-lcs )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '1,2 s:^:#:' spec/suites/rspec_2/spec_helper.rb || die
}

each_ruby_test() {
	# Only run the rspec 2 case since we don't have appraisals. Setting
	# up everything correctly without it seems very complicated.
	ruby-ng_rspec --format progress spec/suites/rspec_2/unit || die
}

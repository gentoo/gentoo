# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGES EXPRESSIONS.md README.md"

RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="An abstraction and a framework for compiling templates to pure Ruby"
HOMEPAGE="https://github.com/judofyr/temple"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/bacon dev-ruby/tilt )"

all_ruby_prepare() {
	# Avoid test failing based on specific load ordering
	sed -i -e '/should have use_html_safe option/,/^  end/ s:^:#:' \
		test/filters/test_escapable.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:test -S bacon --automatic --quiet || die
}

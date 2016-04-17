# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="History.md README.md"

inherit ruby-fakegem

DESCRIPTION="Template engine for Ruby"
HOMEPAGE="http://www.liquidmarkup.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib:test test/liquid/*_test.rb
}

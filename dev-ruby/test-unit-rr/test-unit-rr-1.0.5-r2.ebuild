# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="RR adapter for Test::Unit"
HOMEPAGE="https://github.com/test-unit/test-unit-rr"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rr-1.1.1 >=dev-ruby/test-unit-2.5.2"

each_ruby_test() {
	${RUBY} test/run-test.rb || die
}

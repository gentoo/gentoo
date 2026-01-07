# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt"

inherit ruby-fakegem

DESCRIPTION="Library which enable you to define abstract method in Ruby"
HOMEPAGE="https://rubygems.org/gems/abstract"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib test/test.rb || die "tests failed"
}

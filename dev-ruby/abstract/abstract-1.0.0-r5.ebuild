# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt"

inherit ruby-fakegem

DESCRIPTION="Library which enable you to define abstract method in Ruby"
HOMEPAGE="https://rubygems.org/gems/abstract"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

each_ruby_test() {
	${RUBY} -Ilib test/test.rb || die "tests failed"
}

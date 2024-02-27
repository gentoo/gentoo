# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A collection of thread-safe versions of common core Ruby classes"
HOMEPAGE="https://github.com/ruby-concurrency/thread_safe"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="test"

each_ruby_prepare() {
	sed -i -e "/[Bb]undler/d" Rakefile || die
	sed -i -e '/coveralls/I s:^:#:' \
		-e '/simplecov/ s:^:#:' \
		-e '/SimpleCov/,/^end/ s:^:#:' spec/spec_helper.rb || die
}

each_ruby_test() {
	einfo "The test suite may take up to 10 minutes to run without apparent feedback"
	each_fakegem_test
}

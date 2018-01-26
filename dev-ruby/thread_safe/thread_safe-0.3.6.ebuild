# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="A collection of thread-safe versions of common core Ruby classes"
HOMEPAGE="https://github.com/ruby-concurrency/thread_safe"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Higher atomic dependency since earlier versions crash on ruby20 while
# running thread_safe tests.
ruby_add_bdepend "test? ( >=dev-ruby/atomic-1.1.16 )"

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

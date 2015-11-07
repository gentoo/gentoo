# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="Changelog.md README.rdoc TODO"
RUBY_FAKEGEM_DOCDIR="doc/html"

inherit ruby-fakegem

DESCRIPTION="Highline is a high-level command-line IO library for ruby"
HOMEPAGE="https://github.com/JEG2/highline"

IUSE=""
LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

all_ruby_prepare() {
	# fix up gemspec file not to call git
	sed -i -e '/git ls-files/d' highline.gemspec || die

	# Avoid unneeded dependencies
	sed -i -e '/\(bundler\|code_statistics\)/ s:^:#:' \
		-e '/PackageTask/,/end/ s:^:#:' Rakefile || die

	# Avoid tests that require a real console because we can't provide
	# that when running tests through portage. These should pass when
	# run in a console. We should probably narrow this down more to the
	# specific tests.
	rm test/tc_highline.rb || die

	sed -i -e '/test_question_options/,/^  end/ s:^:#:' \
		-e '/test_paged_print_infinite_loop_bug/,/^  end/ s:^:#:' \
		-e '/test_cancel_paging/,/^  end/ s:^:#:' \
		test/tc_menu.rb || die
}

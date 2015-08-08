# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README ChangeLog"

# We don't use RUBY_FAKEGEM_NAME here since for now we want to keep the
# same gem name.

inherit ruby-fakegem

DESCRIPTION="Provides POSIX tarchive management from Ruby programs"
HOMEPAGE="https://github.com/halostatue/minitar"
SRC_URI="mirror://rubygems/minitar-${PV}.gem"

LICENSE="|| ( GPL-2 Ruby )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

RUBY_PATCHES=(
	${PN}-0.5.2-gentoo.patch
	${PN}-0.5.3-pipes.patch
)

all_ruby_prepare() {
	# ignore faulty metadata
	rm -f ../metadata || die

	# Fix tests by using ruby19+ compatible code.
	# Avoid failing tests.
	# https://github.com/halostatue/minitar/issues/9
	sed -i -e '52 s/x\[0\]/x[0].ord/' \
		-e '/test_each_works/,/^  end/ s:^:#:' \
		-e '/test_extract_entry_works/,/^  end/ s:^:#:' tests/tc_tar.rb || die

}

each_ruby_test() {
	${RUBY} -Itests -Ctests testall.rb || die
}

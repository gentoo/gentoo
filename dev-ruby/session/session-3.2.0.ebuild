# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A set of classes to drive external programs via pipe"
HOMEPAGE="http://codeforpeople.com/lib/ruby/session/"
#SRC_URI="http://codeforpeople.com/lib/ruby/session/${P}.tgz"

# License info based on https://github.com/ahoward/session as indicated
# by author.
LICENSE="Ruby"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="test"

DEPEND+=" test? ( sys-apps/coreutils )"

all_ruby_prepare() {
	# needed to void a collision with the Timeout::Error alias in Ruby
	# 1.8.7 at least.
	sed -i -e 's:TimeoutError:SessionTimeoutError:' test/session.rb || die

	# Fix broken test, bug 662514
	sed -i -e '/cmd =/ s/sleep 0.1"/sleep 0.1";/' test/session.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib test/*.rb || die "tests failed"
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc sample/*
}

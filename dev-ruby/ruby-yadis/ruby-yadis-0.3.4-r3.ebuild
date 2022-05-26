# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A ruby library for performing Yadis service discovery"
HOMEPAGE="http://yadis.rubyforge.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

each_ruby_prepare() {
	# Remove live tests that require content that is no longer available.
	rm test/test_discovery.rb || die
	sed -i -e '/test_discovery/d' test/runtests.rb || die
}

each_ruby_test() {
	${RUBY} -I../lib:lib:test -Ctest runtests.rb || die
}

all_ruby_install() {
	all_fakegem_install

	dodoc -r examples
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

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

	insinto /usr/share/doc/${PF}
	doins -r examples
}

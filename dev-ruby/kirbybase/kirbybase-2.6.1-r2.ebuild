# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_NAME="KirbyBase"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="changes.txt kirbybaserubymanual.html README"

inherit ruby-fakegem

DESCRIPTION="A simple Ruby DBMS that stores data in plaintext files"
HOMEPAGE="http://www.netpromi.com/kirbybase_ruby.html"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/test-unit:2 )"

each_ruby_test() {
	${RUBY} -I.:lib -S testrb-2 test/t*.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples images
}

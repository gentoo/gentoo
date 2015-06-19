# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/kirbybase/kirbybase-2.6.1-r2.ebuild,v 1.3 2015/02/01 15:37:54 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_NAME="KirbyBase"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="changes.txt kirbybaserubymanual.html README"

inherit ruby-fakegem

DESCRIPTION="A simple Ruby DBMS that stores data in plaintext files"
HOMEPAGE="http://www.netpromi.com/kirbybase_ruby.html"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

each_ruby_test() {
	${RUBY} -I.:lib -S testrb test/t*.rb || die
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples images
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/uconv/uconv-0.6.1-r2.ebuild,v 1.1 2015/04/04 07:03:35 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

inherit ruby-ng

DESCRIPTION="A module to convert ISO/IEC 10646 (Unicode) string and Japanese strings"
HOMEPAGE="http://www.yoshidam.net/Ruby.html#uconv"
SRC_URI="http://www.yoshidam.net/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RUBY_S=${PN}

all_ruby_prepare() {
	sed -i -e '/^\$CFLAGS = ""/d' extconf.rb || die "Unable to remove CFLAGS line"
}

each_ruby_configure() {
	${RUBY} extconf.rb || die
}

each_ruby_compile() {
	emake V=1
}

each_ruby_install() {
	emake V=1 DESTDIR="${D}" install
}

all_ruby_install() {
	dodoc README*
}

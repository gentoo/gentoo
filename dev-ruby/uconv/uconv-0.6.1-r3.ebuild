# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit ruby-ng

DESCRIPTION="A module to convert ISO/IEC 10646 (Unicode) string and Japanese strings"
HOMEPAGE="http://www.yoshidam.net/Ruby.html#uconv"
SRC_URI="http://www.yoshidam.net/${P}.tar.gz"
LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"
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

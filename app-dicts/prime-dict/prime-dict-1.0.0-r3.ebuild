# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-ng

DESCRIPTION="Dictionary files for PRIME input method"
HOMEPAGE="http://taiyaki.org/prime/"
SRC_URI="http://prime.sourceforge.jp/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86"
IUSE=""

each_ruby_configure() {
	econf --with-rubydir="$(ruby_rbconfig_value 'sitelibdir')"
}

each_ruby_compile() {
	emake
}

each_ruby_install() {
	emake DESTDIR="${D}" install
}

all_ruby_install() {
	dodoc AUTHORS ChangeLog NEWS README
}

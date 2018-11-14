# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"

DESCRIPTION="Performance monitoring tool capable of interactive reporting and logging to disk"
HOMEPAGE="http://collectl.sourceforge.net/"
SRC_URI="mirror://sourceforge/collectl/${P}.src.tar.gz"

LICENSE="GPL-2 Artistic"
SLOT="0"
KEYWORDS="alpha amd64 ia64 x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.8.8
	virtual/perl-Time-HiRes
	>=dev-perl/Archive-Zip-1.20
	sys-apps/ethtool
	sys-apps/pciutils"

src_prepare() {
	sed -i INSTALL -e "/^DOCDIR/s:doc/collectl:doc/${PF}:" || die
}

src_install() {
	DESTDIR="${D}" bash -ex ./INSTALL || die

	rm "${D}"/etc/init.d/* || die
	newinitd "${FILESDIR}"/collectl.initd-2 collectl

	rm "${D}"/usr/share/${PN}/UNINSTALL || die

	cd "${D}"/usr/share/doc/${PF} || die
	dohtml *
	rm ARTISTIC GPL COPYING *.html *.jpg *.css || die
}

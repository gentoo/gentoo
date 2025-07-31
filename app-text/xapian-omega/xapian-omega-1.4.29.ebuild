# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An application built on Xapian, consisting of indexers and a CGI search frontend"
HOMEPAGE="https://xapian.org/"
SRC_URI="https://oligarchy.co.uk/xapian/${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc x86"

DEPEND="
	dev-lang/perl
	dev-libs/libpcre2:=
	~dev-libs/xapian-${PV}:0/30
	sys-apps/file
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}" install

	# Protect /etc/omega.conf
	echo "CONFIG_PROTECT=\"/etc/omega.conf\"" > "${T}"/20xapian-omega || die
	doenvd "${T}"/20xapian-omega
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO

	# Directory containing Xapian databases:
	keepdir /var/lib/omega/data

	# Directory containing OmegaScript templates:
	keepdir /var/lib/omega/templates
	mv "${S}"/templates/* "${ED}"/var/lib/omega/templates || die

	# Directory to write Omega logs to:
	keepdir /var/log/omega

	# Directory containing any cdb files for the $lookup OmegaScript command:
	keepdir /var/lib/omega/cdb
}

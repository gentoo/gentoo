# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="blackbox weather monitor"
HOMEPAGE="https://www.netmeister.org/apps/bbweather/"
SRC_URI="https://www.netmeister.org/apps/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~hppa ppc x86"

DEPEND="dev-lang/perl
	x11-libs/libX11"
RDEPEND="${DEPEND}
	net-misc/wget
	x11-apps/xmessage"

PATCHES=( "${FILESDIR}"/${PN}-asneeded.patch )

src_prepare() {
	default
	gunzip doc/*.gz || die
	mv configure.{in,ac} || die
	sed -i \
		-e "s:man_DATA:man1_MANS:;s:.gz::g;/^mandir/d" \
		doc/Makefile.am || die
	sed -i \
		-e 's|-helvetica-|-*-|g' \
		resource.cpp data/${PN}.{nobb,style} || die
	sed -i \
		-e 's|register ||' \
		Image.cpp || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" docdir="/usr/share/doc/${PF}" install
	dodoc README AUTHORS ChangeLog NEWS TODO data/README.bbweather

	# since multiple bbtools packages provide this file, install
	# it in /usr/share/doc/${PF}
	mv "${D}"/usr/share/bbtools/bbtoolsrc.in \
		"${D}"/usr/share/doc/${PF}/bbtoolsrc.example || die
}

# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

MY_P="${PN}-core-${PV}"

DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://oligarchy.co.uk/xapian/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/1.3"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static-libs -cpu_flags_x86_sse +cpu_flags_x86_sse2 +brass +chert +inmemory"

COMMON_DEPEND="sys-libs/zlib"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}"

REQUIRED_USE="inmemory? ( chert )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf=""

	einfo
	if use cpu_flags_x86_sse2; then
		einfo "Using sse2"
		myconf="${myconf} --enable-sse=sse2"
	else
		if use cpu_flags_x86_sse; then
			einfo "Using sse"
			myconf="${myconf} --enable-sse=sse"
		else
			einfo "Disabling sse and sse2"
			myconf="${myconf} --disable-sse"
		fi
	fi
	einfo

	myconf="${myconf} $(use_enable static-libs static)"

	use brass || myconf="${myconf} --disable-backend-brass"
	use chert || myconf="${myconf} --disable-backend-chert"
	use inmemory || myconf="${myconf} --disable-backend-inmemory"

	myconf="${myconf} --enable-backend-remote --program-suffix="

	econf $myconf
}

src_install() {
	emake DESTDIR="${D}" install

	mv "${ED}usr/share/doc/xapian-core" "${ED}usr/share/doc/${PF}" || die
	if ! use doc ; then
		rm -r "${ED}usr/share/doc/${PF}" || die
	fi

	dodoc AUTHORS HACKING PLATFORMS README NEWS

	prune_libtool_files
}

src_test() {
	emake check VALGRIND=
}

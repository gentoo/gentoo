# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

MY_P="${PN}-core-${PV}"

DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="http://www.xapian.org/"
SRC_URI="http://oligarchy.co.uk/xapian/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/1.3.8" # ABI version of libxapian-1.3.so, prefixed with 1.3.
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static-libs -cpu_flags_x86_sse +cpu_flags_x86_sse2 +glass +chert +inmemory"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

REQUIRED_USE="inmemory? ( chert )"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf=""

	ewarn
	if use cpu_flags_x86_sse2; then
		ewarn "Using sse2"
		myconf="${myconf} --enable-sse=sse2"
	else
		if use cpu_flags_x86_sse; then
			ewarn "Using sse"
			myconf="${myconf} --enable-sse=sse"
		else
			ewarn "Disabling sse and sse2"
			myconf="${myconf} --disable-sse"
		fi
	fi
	ewarn

	myconf="${myconf} $(use_enable static-libs static)"

	use glass || myconf="${myconf} --disable-backend-glass"
	use chert || myconf="${myconf} --disable-backend-chert"
	use inmemory || myconf="${myconf} --disable-backend-inmemory"

	myconf="${myconf} --enable-backend-remote --program-suffix="

	econf $myconf
}

src_install() {
	emake DESTDIR="${D}" install

	# bug #573466
	ln -sf "${D}usr/bin/xapian-config" "${D}usr/bin/xapian-config-1.3"

	mv "${D}usr/share/doc/xapian-core" "${D}usr/share/doc/${PF}" || die
	use doc || rm -rf "${D}usr/share/doc/${PF}"

	dodoc AUTHORS HACKING PLATFORMS README NEWS

	prune_libtool_files --all
}

src_test() {
	emake check VALGRIND=
}

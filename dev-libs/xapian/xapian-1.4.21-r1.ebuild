# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_P="${PN}-core-${PV}"

DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="https://xapian.org/"
SRC_URI="https://oligarchy.co.uk/xapian/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/30" # ABI version of libxapian.so
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="doc static-libs cpu_flags_x86_sse cpu_flags_x86_sse2 +inmemory +remote"

DEPEND="sys-apps/util-linux
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf=""

	if use cpu_flags_x86_sse2; then
		myconf="${myconf} --enable-sse=sse2"
	else
		if use cpu_flags_x86_sse; then
			myconf="${myconf} --enable-sse=sse"
		else
			myconf="${myconf} --disable-sse"
		fi
	fi

	myconf="${myconf} $(use_enable static-libs static)"

	use inmemory || myconf="${myconf} --disable-backend-inmemory"
	use remote || myconf="${myconf} --disable-backend-remote"

	myconf="${myconf} --enable-backend-glass --enable-backend-chert --program-suffix="

	econf ${myconf}
}

src_test() {
	emake check VALGRIND=
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		rm -rf "${ED}/usr/share/doc/xapian-core-${PV}" || die
	fi

	dodoc AUTHORS HACKING PLATFORMS README NEWS

	find "${ED}" -name "*.la" -type f -delete || die
}

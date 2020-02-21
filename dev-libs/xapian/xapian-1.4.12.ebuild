# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils multilib-minimal

MY_P="${PN}-core-${PV}"

DESCRIPTION="Xapian Probabilistic Information Retrieval library"
HOMEPAGE="https://www.xapian.org/"
SRC_URI="https://oligarchy.co.uk/xapian/${PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/30" # ABI version of libxapian.so
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x64-solaris"
IUSE="doc static-libs -cpu_flags_x86_sse +cpu_flags_x86_sse2 +glass +inmemory +remote"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

multilib_src_configure() {
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

	use glass || myconf="${myconf} --disable-backend-glass"
	use inmemory || myconf="${myconf} --disable-backend-inmemory"
	use remote || myconf="${myconf} --disable-backend-remote"

	myconf="${myconf} --enable-backend-chert --program-suffix="

	ECONF_SOURCE=${S} econf $myconf
}

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/xapian/postingsource.h
	/usr/include/xapian/attributes.h
	/usr/include/xapian/valuesetmatchdecider.h
	/usr/include/xapian/version.h
	/usr/include/xapian/version.h
	/usr/include/xapian/types.h
	/usr/include/xapian/positioniterator.h
	/usr/include/xapian/registry.h
)

multilib_src_test() {
	emake check VALGRIND=
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	if use doc; then
		rm -rf "${D}/usr/share/doc/xapian-core-${PV}" || die
	fi

	dodoc AUTHORS HACKING PLATFORMS README NEWS

	find "${D}" -name "*.la" -type f -delete || die
}

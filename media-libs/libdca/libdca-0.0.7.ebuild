# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="https://www.videolan.org/developers/libdca.html"
SRC_URI="https://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="debug oss"

DOCS=( AUTHORS ChangeLog NEWS README TODO doc/${PN}.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-0.0.5-cflags.patch
	"${FILESDIR}"/${PN}-0.0.5-tests-optional.patch
	"${FILESDIR}"/${PN}-0.0.7-slibtool.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	append-lfs-flags #328875

	local myeconfargs=(
		--disable-static
		$(use_enable debug)
		$(use_enable oss)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"

	# Those are thrown away afterwards, don't build them in the first place
	if [[ "${ABI}" != "${DEFAULT_ABI}" ]] ; then
		sed -e 's/ libao src//' -i Makefile || die
	fi
}

multilib_src_compile() {
	emake OPT_CFLAGS=""
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	find "${D}" -name '*.la' -type f -delete || die
	rm "${D}"/usr/$(get_libdir)/libdts.a || die
}

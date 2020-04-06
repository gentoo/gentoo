# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib

MY_PN="ZenLib"
DESCRIPTION="Shared library for libmediainfo and mediainfo"
HOMEPAGE="https://github.com/MediaArea/ZenLib"
SRC_URI="https://mediaarea.net/download/source/${PN}/${PV}/${P/-/_}.tar.bz2"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

DEPEND="virtual/pkgconfig
	doc? ( app-doc/doxygen )"

S=${WORKDIR}/${MY_PN}/Project/GNU/Library

src_prepare() {
	default
	sed -i 's:-O2::' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-unicode \
		--enable-shared \
		$(use_enable static-libs static)
}

src_compile() {
	default

	if use doc ; then
		cd "${WORKDIR}"/${MY_PN}/Source/Doc
		doxygen Doxyfile || die
	fi
}

src_install() {
	default

	# remove since the pkgconfig file should be used instead
	rm "${D}"/usr/bin/libzen-config

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	for x in ./ Format/Html Format/Http HTTP_Client ; do
		insinto /usr/include/${MY_PN}/${x}
		doins "${WORKDIR}"/${MY_PN}/Source/${MY_PN}/${x}/*.h
	done

	dodoc "${WORKDIR}"/${MY_PN}/History.txt
	if use doc ; then
		docinto html
		dodoc "${WORKDIR}"/${MY_PN}/Doc/*
	fi

	find "${ED}" -name '*.la' -delete || die
}

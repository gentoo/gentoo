# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The backup tool and wonderful emulator's Swiss Army knife program"
HOMEPAGE="http://ucon64.sourceforge.net/"
SRC_URI="mirror://sourceforge/ucon64/${P}-src.tar.gz"
S="${WORKDIR}"/${P}-src/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-ovflfix.patch
	"${FILESDIR}"/${P}-zlib.patch
)

src_prepare() {
	default

	sed -i \
		-e "/^CFLAGS/s/-O3/${CFLAGS}/" \
		-e "/^LDFLAGS/s/-s$/${LDFLAGS}/" \
		{,libdiscmage/}Makefile.in || die
}

src_configure() {
	local myconf

	if [[ ! -e "${ESYSROOT}"/usr/include/sys/io.h ]] ; then
		ewarn "Disabling support for parallel port"
		myconf="${myconf} --disable-parallel"
	fi

	econf ${myconf}
}

src_install() {
	dobin ucon64
	dolib.so libdiscmage/discmage.so

	cd .. || die

	docinto html
	dodoc *.html
	docinto html/images
	dodoc images/*
}

pkg_postinst() {
	echo
	elog "In order to use ${PN}, please create the directory ~/.ucon64/dat"
	elog "The command to do that is:"
	elog "    mkdir -p ~/.ucon64/dat"
	elog "Then, you can copy your DAT file collection to ~/.ucon64/dat"
	elog
	elog "To enable Discmage support, cp /usr/lib/discmage.so to ~/.ucon64"
	elog "The command to do that is:"
	elog "    cp /usr/lib/discmage.so ~/.ucon64/"
	elog
	elog "Be sure to check ~/.ucon64rc for some options after"
	elog "you've run uCON64 for the first time"
}

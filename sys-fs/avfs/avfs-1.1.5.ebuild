# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual filesystem that allows browsing of compressed files"
HOMEPAGE="https://sourceforge.net/projects/avf/"
SRC_URI="https://downloads.sourceforge.net/avf/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE="lzip +lzma webdav +zstd"

RDEPEND="
	app-arch/bzip2:=
	>=sys-fs/fuse-2.4:0
	sys-libs/zlib
	lzip? ( app-arch/lzlib )
	lzma? ( app-arch/xz-utils )
	webdav? ( net-libs/neon:= )
	zstd? ( app-arch/zstd:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/libtool
	virtual/pkgconfig
"

src_configure() {
	myeconfargs=(
		--enable-fuse
		--enable-library
		--enable-shared
		--with-system-zlib
		--with-system-bzlib
		--disable-static
		$(use_enable webdav dav)
		$(use_with lzip)
		$(use_with lzma xz)
		$(use_with zstd)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# remove cruft
	rm "${ED}"/usr/bin/{davpass,ftppass} || die

	# install docs
	dodoc doc/{api-overview,background,FORMAT,INSTALL.*,README.avfs-fuse}
	dosym ../../../$(get_libdir)/avfs/extfs/README /usr/share/doc/${PF}/README.extfs

	docinto scripts
	dodoc scripts/*pass

	find "${ED}" -name "*.la" -delete || die
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		einfo "This version of AVFS includes FUSE support. It is user-based."
		einfo "To execute:"
		einfo "1) as user, mkdir ~/.avfs"
		einfo "2) make sure fuse is either compiled into the kernel OR"
		einfo "   modprobe fuse or add to startup."
		einfo "3) run mountavfs"
		einfo "To unload daemon, type umountavfs"
		einfo
		einfo "READ the documentation! Enjoy :)"
	fi
}

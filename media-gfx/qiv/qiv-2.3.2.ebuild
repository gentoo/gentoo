# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop toolchain-funcs vcs-snapshot xdg

DESCRIPTION="Quick Image Viewer"
HOMEPAGE="http://spiegl.de/qiv/ https://bitbucket.org/ciberandy/qiv"
SRC_URI="https://bitbucket.org/ciberandy/qiv/get/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="exif lcms magic"

RDEPEND="
	media-libs/imlib2[X]
	>=x11-libs/gtk+-2.12:2
	exif? ( media-libs/libexif )
	lcms? (
		media-libs/lcms:2
		media-libs/tiff:0
		virtual/jpeg:0
	)
	magic? ( sys-apps/file )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-optional-tiff.patch )

src_prepare() {
	default

	sed -i \
		-e 's:$(CC) $(CFLAGS):$(CC) $(LDFLAGS) $(CFLAGS):' \
		Makefile || die

	if ! use exif ; then
		sed -i 's/^EXIF =/#\0/' Makefile || die
	fi

	if ! use lcms ; then
		sed -i 's/^LCMS =/#\0/' Makefile || die
	fi

	if ! use magic ; then
		sed -i 's/^MAGIC =/#\0/' Makefile || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin qiv
	doman qiv.1
	dodoc Changelog contrib/qiv-command.example README README.TODO

	domenu qiv.desktop
	doicon qiv.png
}

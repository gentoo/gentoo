# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A network scanning tool for pentesters"
HOMEPAGE="https://www.thc.org/thc-amap/"
SRC_URI="https://www.thc.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 x86"
IUSE="libressl ssl"

DEPEND="
	dev-libs/libpcre
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
RDEPEND="
	${DEPEND}
	!sci-biology/amap
"

PATCHES=(
	"${FILESDIR}"/4.8-system-pcre.patch
)

src_prepare() {
	rm -r pcre-3.9 || die

	sed -i -e "s:etc/:share/amap/:g" amap-lib.c || die

	# Above change requires below change. See sources...
	sed -i '/strlen(AMAP_PREFIX/s: 5 : 12 :' amap-lib.c || die
	sed -i 's:/usr/local:/usr:' amap.h || die

	# Files to be updated are at different location, bug 207839.
	sed -i '/AMAP_RESOURCE/s:www:freeworld:' amap.h || die

	sed -i '/DATADIR/s:/etc:/share/amap:' Makefile.am || die

	default
}

src_configure() {
	# non-autotools configure script
	./configure || die

	sed -i \
		-e '/^XDEFINES=/s:=.*:=:' \
		-e '/^XLIBS=/s:=.*:=:' \
		-e '/^XLIBPATHS/s:=.*:=:' \
		-e '/^XIPATHS=/s:=.*:=:' \
		-e "/^CC=/d" \
		Makefile || die

	if use ssl ; then
		sed -i \
			-e '/^XDEFINES=/s:=:=-DOPENSSL:' \
			-e '/^XLIBS=/s:=:=-lcrypto -lssl:' \
			Makefile || die
	fi

	sed -i Makefile \
		-e '/-o amap/{s|(OPT) |(OPT) $(LDFLAGS) |g}' \
		|| die
}

src_compile() {
	emake CC=$(tc-getCC) OPT="${CFLAGS}"
}

src_install() {
	dobin amap amapcrap
	insinto /usr/share/amap
	doins appdefs.*

	doman ${PN}.1
	dodoc README TODO CHANGES
}

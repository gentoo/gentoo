# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit unpacker toolchain-funcs flag-o-matic

DESCRIPTION="pax (Portable Archive eXchange) is the POSIX standard archive tool"
HOMEPAGE="https://www.mirbsd.org/pax.htm"
SRC_URI="https://www.mirbsd.org/MirOS/dist/mir/cpio/paxmirabilis-${PV}.cpio.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"

RDEPEND="
	dev-libs/libbsd
	elibc_musl? ( sys-libs/fts-standalone )
"
DEPEND="
	${RDEPEND}
	$(unpacker_src_uri_depends)
"
PATCHES=(
	"${FILESDIR}/${PN}-20160306-glibc-to-linux.patch"
)
S=${WORKDIR}/${PN}

src_prepare() {
	# Newer C libraries omit this include from sys/types.h.
	sed -i '1i#include <sys/sysmacros.h>' extern.h || die
	default
}

src_configure() {
	tc-export CC PKG_CONFIG
}

src_compile() {
	use elibc_musl && append-ldflags "-lfts"

	# We can't rely on LFS flags as it uses the fts.h interface which lacks 64-bit support.
	set -- \
		${CC} ${CPPFLAGS} ${CFLAGS} \
		-DPAX_SAFE_PATH=\"/bin:/usr/bin\" \
		-DHAVE_STRLCPY -DHAVE_VIS -DHAVE_STRMODE \
		-DLONG_OFF_T -DHAVE_LINKAT \
		$(${PKG_CONFIG} --cflags libbsd-overlay) \
		-Wall ${LDFLAGS} *.c -o ${PN} \
		$(${PKG_CONFIG} --libs libbsd-overlay)
	echo "$@"
	"$@" || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1

	dosym pax /usr/bin/paxcpio
	newman cpio.1 paxcpio.1

	dosym pax /usr/bin/paxtar
	newman tar.1 paxtar.1
}

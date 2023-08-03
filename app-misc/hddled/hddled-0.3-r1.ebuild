# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Show hard disk activity using the scroll lock LED"
HOMEPAGE="http://members.optusnet.com.au/foonly/whirlpool/code/"
SRC_URI="mirror://gentoo/${P}.c.xz"
S="${WORKDIR}"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.3-fix-missing-temp_failure_retry.patch"
)

src_prepare() {
	mv ${P}.c ${PN}.c || die
	default
}

src_compile() {
	if use elibc_musl ; then
		append-libs -largp
	fi

	$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -o ${PN} ${PN}.c ${LDFLAGS} ${LIBS} || die

	if use X ; then
		$(tc-getCC) ${CFLAGS} ${CPPFLAGS} -DX -lX11 -o x${PN} ${PN}.c ${LDFLAGS} ${LIBS} || die
	fi
}

src_install() {
	dobin ${PN}

	if use X ; then
		dobin x${PN}
		elog "X version was renamed to x${PN}"
	fi
}

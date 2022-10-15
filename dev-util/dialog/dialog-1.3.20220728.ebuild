# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-$(ver_rs 2 -)
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="Tool to display dialog boxes from a shell"
HOMEPAGE="https://invisible-island.net/dialog/"
SRC_URI="https://invisible-island.net/archives/dialog/${MY_P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/dialog/${MY_P}.tgz.asc )"
S="${WORKDIR}"/${MY_P}

LICENSE="LGPL-2.1"
SLOT="0/15"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="examples minimal nls unicode"

RDEPEND=">=sys-libs/ncurses-5.2-r5:=[unicode(+)?]"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	"
BDEPEND="
	virtual/pkgconfig
	!minimal? ( sys-devel/libtool )
	verify-sig? ( sec-keys/openpgp-keys-thomasdickey )
"

src_prepare() {
	default

	sed -i -e '/LIB_CREATE=/s:${CC}:& ${LDFLAGS}:g' configure || die
	sed -i '/$(LIBTOOL_COMPILE)/s:$: $(LIBTOOL_OPTS):' makefile.in || die
}

src_configure() {
	if [[ ${CHOST} == *-darwin* ]] ; then
		export ac_cv_prog_LIBTOOL=glibtool
	fi

	econf \
		--disable-rpath-hack \
		--with-pkg-config \
		$(use_enable nls) \
		$(use_with !minimal libtool) \
		--with-libtool-opts='-shared' \
		--with-ncurses$(usex unicode w '')
}

src_install() {
	use minimal && default || emake DESTDIR="${D}" install-full

	use examples && dodoc -r samples

	dodoc CHANGES README

	find "${ED}" -name '*.la' -delete || die
}

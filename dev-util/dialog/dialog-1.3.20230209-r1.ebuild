# Copyright 1999-2023 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="examples minimal nls unicode"

RDEPEND=">=sys-libs/ncurses-5.2-r5:=[unicode(+)?]"
DEPEND="
	${RDEPEND}
	nls? ( sys-devel/gettext )
	!minimal? ( sys-devel/libtool )
"
BDEPEND="
	virtual/pkgconfig
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
		--with-pkg-config-libdir="${EPREFIX}/usr/$(get_libdir)/pkgconfig" \
		--enable-pc-files \
		$(use_enable nls) \
		$(use_with !minimal libtool) \
		--with-libtool-opts='-shared' \
		--with-shared \
		--with-shlib-version=abi \
		--with-ncurses$(usev unicode w)
	# --with-libtool accepts an argument for the libtool executable path
	# but since the build script is broken any value that is not 'yes' will
	# be treated as no, so we have to specify LIBTOOL= to emake below.
	MYMAKEARGS=(
		LIBTOOL="${ESYSROOT}/usr/bin/libtool"
	)
}

src_compile () {
	# Generate the .pc file during src_compile, not src_install
	emake "${MYMAKEARGS[@]}" all dialog.pc

	# dialog.pc includes -I args from $CFLAGS and -L args from $LDFLAGS from when the library was built.
	# If $ESYSROOT is not `/` these values become invalid.
	if [[ -n ${ESYSROOT} && ${ESYSROOT} != / ]]; then
		sed -i "s,${ESYSROOT},,g" dialog.pc || die "Could not fix the dialog.pc file"
	fi
}

src_install() {
	MYMAKEARGS+=( DESTDIR="${D}" )
	use minimal && emake "${MYMAKEARGS[@]}" install || emake "${MYMAKEARGS[@]}" install-full

	use examples && dodoc -r samples

	dodoc CHANGES README

	find "${ED}" -name '*.la' -delete || die
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="complete ODBC driver manager"
HOMEPAGE="http://www.unixodbc.org/ https://github.com/lurcher/unixODBC"
SRC_URI="https://github.com/lurcher/unixODBC/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+minimal odbcmanual static-libs stats unicode"

RDEPEND="
	|| (
		dev-libs/libltdl:0[${MULTILIB_USEDEP}]
		>=sys-devel/libtool-2.4.2-r1[${MULTILIB_USEDEP}]
	)
	>=sys-libs/readline-6.2_p5-r1:0=[${MULTILIB_USEDEP}]
	>=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
	virtual/libcrypt:=
"
DEPEND="
	${RDEPEND}
	sys-devel/flex
"

MULTILIB_CHOST_TOOLS=( /usr/bin/odbc_config )
MULTILIB_WRAPPED_HEADERS=( /usr/include/unixodbc_conf.h )

multilib_src_configure() {
	# --enable-driver-conf is --enable-driverc as per configure.in
	local myeconfargs=(
		--cache-file="${BUILD_DIR}"/config.cache
		--sysconfdir="${EPREFIX}"/etc/${PN}
		--disable-editline
		--enable-iconv
		--enable-shared
		$(use_enable !minimal drivers)
		$(use_enable !minimal driverc)
		$(use_enable static-libs static)
		$(use_enable stats stats)
		$(use_with unicode iconv-char-enc UTF8)
		$(use_with unicode iconv-ucode-enc UTF16LE)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	if use odbcmanual ; then
		# We could simply run "make install-html" if we'd not had
		# out-of-source builds here.
		docinto html
		dodoc -r doc/.
		find "${ED}/usr/share/doc/${PF}/html" -name "Makefile*" -delete || die
	fi

	use prefix && dodoc README*
	find "${ED}" -type f -name '*.la' -delete || die
}

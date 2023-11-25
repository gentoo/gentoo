# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

GNOME_ORG_MODULE="gamin"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools gnome.org multilib-minimal

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="https://www.gnome.org/~veillard/gamin/"
SRC_URI="${SRC_URI}
	mirror://gentoo/gamin-0.1.9-freebsd.patch.bz2
	https://dev.gentoo.org/~grobian/patches/libgamin-0.1.10-opensolaris.patch.bz2
	https://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz" # pkg.m4 for eautoreconf

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug static-libs"

RESTRICT="test" # needs gam-server

RDEPEND="
	!app-admin/fam
	!<app-admin/gamin-0.1.10"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1.10-noinst-lib.patch
	"${FILESDIR}/${PN}-0.1.10-G_CONST_RETURN-removal.patch"
	#"${FILESDIR}/${PN}-0.1.10-crosscompile-fix.patch"
	"${FILESDIR}/${P}-armel-features.patch"
	"${FILESDIR}/${PN}-0.1.10-deadlock.patch"
	"${FILESDIR}/${PN}-0.1.10-musl-pthread.patch"
	"${FILESDIR}"/${PN}-0.1.10-compilewarnings.patch
)

src_prepare() {
	default
	mv "${WORKDIR}"/pkg-config-*/pkg.m4 "${WORKDIR}"/ || die

	# Drop DEPRECATED flags
	sed -i -e 's:-DG_DISABLE_DEPRECATED:$(NULL):g' server/Makefile.am || die

	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.in || die #466962

	mv configure.in configure.ac || die
	# autoconf is required as the user-cflags patch modifies configure.in
	# however, elibtoolize is also required, so when the above patch is
	# removed, replace the following call with a call to elibtoolize
	AT_M4DIR="${WORKDIR}" eautoreconf
}

multilib_src_configure() {
	local myconf=(
		$(use_enable static-libs static)
		--disable-debug
		--disable-server
		$(use_enable kernel_linux inotify)
		$(use_enable debug debug-api)
		--without-python
	)
	local ECONF_SOURCE=${S}

	econf "${myconf[@]}"
}

multilib_src_install_all() {
	DOCS=( AUTHORS ChangeLog README TODO NEWS doc/*txt )
	HTML_DOCS=( doc/*.{html,gif} )
	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}

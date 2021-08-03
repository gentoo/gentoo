# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-$(ver_rs 2 -)"

DESCRIPTION="A library of curses widgets"
HOMEPAGE="https://dickey.his.com/cdk/cdk.html"
SRC_URI="ftp://ftp.invisible-island.net/cdk/${MY_P}.tgz"
S="${WORKDIR}"/${MY_P}

LICENSE="BSD"
SLOT="0/6" # subslot = soname version
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples unicode"

DEPEND="sys-libs/ncurses:=[unicode(+)?]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-5.0.20120323-parallel-make.patch )

src_configure() {
	if [[ ${CHOST} == *-*-darwin* ]] ; then
		export ac_cv_prog_LIBTOOL=glibtool
	fi

	# --with-libtool dropped for now because of broken Makefile
	# bug #790773
	econf \
		--disable-rpath-hack \
		--with-shared \
		--with-pkg-config \
		--with-ncurses$(usex unicode "w" "")
}

src_install() {
	# parallel make installs duplicate libs
	emake -j1 \
		DESTDIR="${D}" \
		DOCUMENT_DIR="${ED}/usr/share/doc/${PF}" \
		install

	if use examples ; then
		local x
		for x in include c++ demos examples cli cli/utils cli/samples ; do
			docinto ${x}
			find ${x} -maxdepth 1 -mindepth 1 -type f -print0 | xargs -0 dodoc || die
		done
	fi

	find "${ED}" \( -name '*.a' -or -name '*.la' \) -delete || die
}

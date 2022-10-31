# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-$(ver_rs 2 -)"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="A library of curses widgets"
HOMEPAGE="https://dickey.his.com/cdk/cdk.html https://github.com/ThomasDickey/cdk-snapshots"
SRC_URI="https://invisible-island.net/archives/${PN}/${MY_P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${MY_P}.tgz.asc )"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0/6" # subslot = soname version
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="examples unicode"

DEPEND="sys-libs/ncurses:=[unicode(+)?]"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-thomasdickey )
"

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

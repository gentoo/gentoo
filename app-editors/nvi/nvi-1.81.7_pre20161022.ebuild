# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools db-use flag-o-matic

DESCRIPTION="Vi clone"
HOMEPAGE="https://sites.google.com/a/bostic.com/keithbostic/vi"
SRC_URI="https://repo.or.cz/nvi.git/snapshot/f462fedd26f78eec1998da4b9cba360095a6aa53.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nvi-f462fed"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x64-macos"
IUSE="perl tcl unicode"

DEPEND=">=sys-libs/db-4.2.52_p5:=
	>=sys-libs/ncurses-5.6-r2:=
	perl? ( dev-lang/perl )
	tcl? ( >=dev-lang/tcl-8.5:0= )"

BDEPEND="virtual/pkgconfig"

RDEPEND="${DEPEND}
	app-eselect/eselect-vi"

REQUIRED_USE="tcl? ( !unicode )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.81.7-strlen-macro-renaming.patch
	"${FILESDIR}"/${PN}-1.81.7-db44.patch
	"${FILESDIR}"/${PN}-1.81.6-db.patch
	"${FILESDIR}"/${PN}-1.81.6-printf-types.patch
	"${FILESDIR}"/${PN}-1.81.7-distrib.patch
)

src_prepare() {
	default

	cd dist || die
	chmod +x findconfig || die

	./distrib || die

	sed -i -e "s@-ldb@-l$(db_libname)@" configure.ac || die
	sed -i -e "s@^install-\(.*\)-local:@install-\1-hook:@" Makefile.am || die
	eautoreconf -Im4
}

src_configure() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use unicode && myconf="${myconf} --enable-widechar"
	use tcl && myconf="${myconf} --enable-tclinterp"

	append-cppflags "-D_PATH_MSGCAT=\"\\\"${EPREFIX}/usr/share/vi/catalog/\\\"\""
	append-cppflags -I"$(db_includedir)"

	# Darwin doesn't have stropts.h, bug #619416
	[[ ${CHOST} == *-darwin* ]] && export vi_cv_sys5_pty=no

	pushd dist 2>/dev/null || die
	econf \
		--program-prefix=n \
		${myconf}
	popd 2>/dev/null || die
}

src_compile() {
	emake -C dist
}

src_install() {
	emake -C dist DESTDIR="${D}" install
}

pkg_postinst() {
	einfo "Setting /usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating /usr/bin/vi symlink"
	eselect vi update --if-unset
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools db-use flag-o-matic

DBVERS="4.8.30 4.7 4.6 4.5 4.4 4.3 4.2"
DBSLOTS=
DBDEPENDS=
for DBVER in ${DBVERS}
do
	if [[ ${DBVER} = *.*.* ]]; then
		DBSLOTS="${DBSLOTS} ${DBVER%.*}"
		DBDEPENDS="${DBDEPENDS} >=sys-libs/db-${DBVER}:${DBVER%.*}"
	else
		DBSLOTS="${DBSLOTS} ${DBVER}"
		DBDEPENDS="${DBDEPENDS} sys-libs/db:${DBVER}"
	fi
done

DESCRIPTION="Vi clone"
HOMEPAGE="https://sites.google.com/a/bostic.com/keithbostic/vi"
SRC_URI="http://garage.linux.student.kuleuven.be/~skimo/nvi/devel/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="perl tcl unicode"

CDEPEND="|| ( ${DBDEPENDS} )
	>=sys-libs/ncurses-5.6-r2:=
	perl? ( dev-lang/perl )
	tcl? ( !unicode? ( >=dev-lang/tcl-8.5:0 ) )"

DEPEND="${CDEPEND}
	virtual/pkgconfig"

RDEPEND="${CDEPEND}
	app-eselect/eselect-vi"

REQUIRED_USE="tcl? ( !unicode )"

PATCHES=(
	"${FILESDIR}"/${P}-strlen-macro-renaming.patch
	"${FILESDIR}"/${P}-db44.patch
	"${FILESDIR}"/${P}-db.patch
	"${FILESDIR}"/${P}-perl-as-needed.patch
	"${FILESDIR}"/${P}-perl-shortnames.patch
	"${FILESDIR}"/${P}-ac_config_header.patch
	"${FILESDIR}"/${P}-use_pkgconfig_for_ncurses.patch
	"${FILESDIR}"/${P}-printf-types.patch
	)

src_prepare() {
	default

	cd dist || die
	chmod +x findconfig || die

	mv configure.{in,ac} || die
	sed -i -e "s@-ldb@-l$(db_libname ${DBSLOTS})@" configure.ac || die
	sed -i -e "s@^install-\(.*\)-local:@install-\1-hook:@" Makefile.am || die
	eautoreconf -Im4
}

src_configure() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use unicode && myconf="${myconf} --enable-widechar"
	use tcl && ! use unicode && myconf="${myconf} --enable-tclinterp"

	append-cppflags '-D_PATH_MSGCAT="\"/usr/share/vi/catalog/\""'
	append-cppflags -I"$(db_includedir ${DBSLOTS})"

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

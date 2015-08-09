# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools db-use eutils flag-o-matic

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
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="perl tcl unicode"

CDEPEND="|| ( ${DBDEPENDS} )
	>=sys-libs/ncurses-5.6-r2
	perl? ( dev-lang/perl )
	tcl? ( !unicode? ( >=dev-lang/tcl-8.5:0 ) )"

DEPEND="${CDEPEND}
		virtual/pkgconfig"

RDEPEND="${CDEPEND}
	app-eselect/eselect-vi"

REQUIRED_USE="tcl? ( !unicode )"

src_prepare() {

	epatch "${FILESDIR}"/${P}-db44.patch
	epatch "${FILESDIR}"/${P}-db.patch
	epatch "${FILESDIR}"/${P}-perl-as-needed.patch
	epatch "${FILESDIR}"/${P}-perl-shortnames.patch
	epatch "${FILESDIR}"/${P}-ac_config_header.patch
	epatch "${FILESDIR}"/${P}-use_pkgconfig_for_ncurses.patch

	cd dist || die
	chmod +x findconfig || die

	append-cppflags -I"$(db_includedir ${DBSLOTS})"

	sed -i -e "s@-ldb@-l$(db_libname ${DBSLOTS})@" configure.in || die
	rm -f configure || die
	eautoreconf -Im4
}

src_configure() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use unicode && myconf="${myconf} --enable-widechar"
	use tcl && ! use unicode && myconf="${myconf} --enable-tclinterp"

	append-cppflags '-D_PATH_MSGCAT="\"/usr/share/vi/catalog/\""'

	pushd dist 2>/dev/null
	econf \
		--program-prefix=n \
		${myconf} \
		|| die "configure failed"
	popd 2>/dev/null
}

src_compile() {
	pushd dist 2>/dev/null
	emake || die "make failed"
	popd 2>/dev/null
}

src_install() {
	pushd dist 2>/dev/null
	emake -j1 DESTDIR="${D}" install || die "install failed"
	popd 2>/dev/null
}

pkg_postinst() {
	einfo "Setting /usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating /usr/bin/vi symlink"
	eselect vi update --if-unset
}

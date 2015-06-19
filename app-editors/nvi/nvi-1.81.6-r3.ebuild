# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nvi/nvi-1.81.6-r3.ebuild,v 1.17 2015/03/31 17:32:04 ulm Exp $

EAPI=5

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
HOMEPAGE="https://sites.google.com/a/bostic.com/keithbostic/nvi"
SRC_URI="http://garage.linux.student.kuleuven.be/~skimo/nvi/devel/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="perl tcl unicode"

DEPEND="|| ( ${DBDEPENDS} )
	>=sys-libs/ncurses-5.6-r2[tinfo]
	perl? ( dev-lang/perl )
	tcl? ( !unicode? ( >=dev-lang/tcl-8.5:0 ) )"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi"

S=${WORKDIR}/${P}/build.unix

pkg_setup() {
	if use tcl && use unicode
	then
		ewarn "nvi does not support tcl+unicode. tcl support will not be included."
		ewarn "If you need tcl support, please disable the unicode flag."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-db44.patch
	epatch "${FILESDIR}"/${P}-db.patch
	epatch "${FILESDIR}"/${P}-perl-as-needed.patch
	epatch "${FILESDIR}"/${P}-perl-shortnames.patch
	cd dist || die
	chmod +x findconfig || die
	append-flags -I"$(db_includedir ${DBSLOTS})"
	sed -i -e "s@-ldb@-l$(db_libname ${DBSLOTS})@" configure.in || die
	rm -f configure || die
	eautoreconf -Im4
}

src_compile() {
	local myconf

	use perl && myconf="${myconf} --enable-perlinterp"
	use tcl && ! use unicode && myconf="${myconf} --enable-tclinterp"
	use unicode && myconf="${myconf} --enable-widechar"

	append-flags '-D_PATH_MSGCAT="\"/usr/share/vi/catalog/\""'

	ECONF_SOURCE=../dist econf \
		--program-prefix=n \
		${myconf} \
		|| die "configure failed"
	emake OPTFLAG="${CFLAGS}" || die "make failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "install failed"
}

pkg_postinst() {
	einfo "Setting /usr/bin/vi symlink"
	eselect vi update --if-unset
}

pkg_postrm() {
	einfo "Updating /usr/bin/vi symlink"
	eselect vi update --if-unset
}

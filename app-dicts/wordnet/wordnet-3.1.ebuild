# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="A lexical database for the English language"
HOMEPAGE="https://wordnet.princeton.edu/"
SRC_URI="
	http://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.gz
	mirror://gentoo/${PN}-3.0-patchset-1.tar.bz2
	http://wordnetcode.princeton.edu/wn3.1.dict.tar.gz"
LICENSE="Princeton"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE="doc"

# In contrast to what the configure script seems to imply, Tcl/Tk is NOT
# optional. cf. bug 163478 for details. (Yes, it's about 2.1 but it's
# still the same here.)
DEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0="
RDEPEND="${DEPEND}"

S="${WORKDIR}/WordNet-3.0"

PATCHES1=(
	# Don't install into PREFIX/dict but PREFIX/share/wordnet/dict
	"${WORKDIR}/"${PN}-3.0"-dict-location.patch"
	# Fixes bug 130024, make an additional shared lib
	"${WORKDIR}/"${PN}-3.0"-shared-lib.patch"
	# Don't install the docs directly into PREFIX/doc but PREFIX/doc/PN
	"${WORKDIR}/"${PN}-3.0"-docs-path.patch"
	"${WORKDIR}"/"${PN}-3.0"-CVE-2008-3908.patch #211491

	"${FILESDIR}"/"${PN}-3.0"-tcl8.6.patch
	"${FILESDIR}"/"${PN}-3.0"-format-security.patch
	"${FILESDIR}"/"${PN}-3.0"-src_stubs_c.patch
	"${FILESDIR}"/"${PN}-3.0"-fix-indexing-bug-314799.patch
)

PATCHES0=(
	"${WORKDIR}"/"${PN}-3.0"-CVE-2008-2149.patch #211491
)

src_prepare() {
	eapply -p1 "${PATCHES1[@]}"
	eapply -p0 "${PATCHES0[@]}"
	eapply_user

	# Don't install all the extra docs (html, pdf, ps) without doc USE flag.
	if ! use doc; then
		sed -i -e "s:SUBDIRS =.*:SUBDIRS = man:" doc/Makefile.am || die
	fi

	# Drop installation of OLD tk.h headers #255590
	sed '/^SUBDIRS/d' -i include/Makefile.am || die
	sed 's: include/tk/Makefile::' -i configure.ac || die
	eautoreconf
}

src_configure() {
	append-cppflags -DUNIX -I"${T}"/usr/include

	PLATFORM=linux WN_ROOT="${T}/usr" \
	WN_DICTDIR="${T}/usr/share/wordnet/dict" \
	WN_MANDIR="${T}/usr/share/man" \
	WN_DOCDIR="${T}/usr/share/doc/wordnet-3.0" \
	WNHOME="${EPREFIX}/usr/share/wordnet" \
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir)
}

src_compile(){
	emake -e
}

src_install(){
	# For clarification, WN is still on  version 3.0. Only the database files
	# have been updated to 3.1 as a package for 3.1 does not currently exist.
	emake -e DESTDIR="${D}" install
	einstalldocs
	rm -r "${D}/usr/share/wordnet/dict" || die
	mv "${WORKDIR}/dict" "${D}/usr/share/wordnet" || die
}

pkg_postinst(){
	elog "The WordNet 3.1 ebuild has installed WordNet v3.0 with v3.1 database files instead."
	elog "See https://wordnet.princeton.edu/download/current-version/ for more."
}

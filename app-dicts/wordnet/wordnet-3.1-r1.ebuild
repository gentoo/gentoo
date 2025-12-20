# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A lexical database for the English language"
HOMEPAGE="https://wordnet.princeton.edu/"
SRC_URI="
	http://wordnetcode.princeton.edu/3.0/WordNet-3.0.tar.gz
	http://wordnetcode.princeton.edu/wn3.1.dict.tar.gz
	https://dev.gentoo.org/~soap/distfiles/${PN}-3.0-patchset-2.tar.xz"
S="${WORKDIR}/WordNet-3.0"

LICENSE="Princeton"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv ~x86"

# In contrast to what the configure script seems to imply, Tcl/Tk is NOT
# optional. cf. bug 163478 for details. (Yes, it's about 2.1 but it's
# still the same here.)
DEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/patches/${PN}-3.0-build-system.patch

	"${WORKDIR}"/patches/${PN}-3.0-CVE-2008-3908.patch #211491
	"${WORKDIR}"/patches/${PN}-3.0-tcl8.6.patch
	"${WORKDIR}"/patches/${PN}-3.0-format-security.patch
	"${WORKDIR}"/patches/${PN}-3.0-src_stubs_c.patch
	"${WORKDIR}"/patches/${PN}-3.0-fix-indexing-bug-314799.patch
	"${WORKDIR}"/patches/${PN}-3.0-CVE-2008-2149.patch #211491
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cppflags -DUNIX -I"${T}"/usr/include

	PLATFORM=linux \
	WN_ROOT="${T}"/usr \
	WN_DICTDIR="${T}"/usr/share/wordnet/dict \
	WN_MANDIR="${T}"/usr/share/man \
	WN_DOCDIR="${T}"/usr/share/doc/wordnet-3.0 \
	WNHOME="${EPREFIX}"/usr/share/wordnet \
	econf \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	default

	# For clarification: WN is still on  version 3.0. Only the database files
	# have been updated to 3.1 as a package for 3.1 does not currently exist.
	rm -r "${ED}"/usr/share/wordnet/dict || die
	insinto /usr/share/wordnet
	doins -r "${WORKDIR}"/dict

	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog "The WordNet 3.1 ebuild has installed WordNet v3.0 with v3.1 database files instead."
	elog "See https://wordnet.princeton.edu/download/current-version/ for more."
}

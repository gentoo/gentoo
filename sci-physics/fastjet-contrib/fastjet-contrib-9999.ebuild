# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit subversion toolchain-funcs

MY_PN=fjcontrib
MY_P=${MY_PN}-${PV}

DESCRIPTION="3rd party extensions of FastJet."
HOMEPAGE="https://fastjet.hepforge.org/contrib/"
ESVN_REPO_URI="https://svn.hepforge.org/fastjetsvn/contrib/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

DEPEND=">=sci-physics/fastjet-3.4.1[plugins]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.049-ar.patch
	"${FILESDIR}"/${PN}-1.055-ar-part2.patch # https://github.com/fjcontrib/fjcontrib/issues/3
	"${FILESDIR}"/${PN}-1.101-ldflags.patch
)

src_unpack() {
	subversion_src_unpack
	subversion_wc_info || die "subversion_wc_info fails."
	# We need the .svn folder for fetching contributions => copy it
	rsync -rlpgo "${ESVN_WC_PATH}/.svn" "${S}" || die "can't copy .svn."
	cd "${S}" || die "svn should have created ${S}."
	./scripts/update-contribs.sh || die "can't fetch contributions"
}

src_configure() {
	tc-export CXX AR RANLIB
	./configure \
		--prefix="${ESYSROOT}/usr" \
		--fastjet-config="${ESYSROOT}/usr/bin/fastjet-config" \
		RANLIB="${RANLIB}" \
		AR="${AR}" \
		CXX="${CXX}" \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		FFLAGS="${FFLAGS}" \
		LDFLAGS="${LDFLAGS}" || die
}

src_compile() {
	emake
	emake fragile-shared
}

src_install() {
	emake install PREFIX="${ED}/usr"
	dolib.so libfastjetcontribfragile.so
	# The name used for requesting this library varies
	dosym libfastjetcontribfragile.so /usr/$(get_libdir)/libfastjetcontribfragile.so.0
	dosym libfastjetcontribfragile.so /usr/$(get_libdir)/fastjetcontribfragile.so.0
}

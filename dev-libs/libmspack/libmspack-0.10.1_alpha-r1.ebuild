# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/kyz/libmspack.git"
	inherit git-r3
	MY_P="${PN}-9999"
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos ~x64-solaris"
	MY_PV="${PV/_alpha/alpha}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://www.cabextract.org.uk/libmspack/libmspack-${MY_PV}.tar.gz"
fi

DESCRIPTION="A library for Microsoft compression formats"
HOMEPAGE="https://www.cabextract.org.uk/libmspack/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug doc"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	if [[ ${PV} == *9999 ]] ; then
		# Re-create file layout from release tarball
		pushd "${WORKDIR}" > /dev/null || die

		cp -aL "${S}"/${PN} "${WORKDIR}"/${PN}-source || die
		rm -r "${S}" || die
		mv "${WORKDIR}"/${PN}-source "${S}" || die

		popd > /dev/null || die
	fi

	default

	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_test() {
	default

	cd "${S}"/test || die
	./cabd_test || die
}

src_install() {
	use doc && HTML_DOCS=( doc/. )

	default

	if use doc ; then
		rm "${ED}"/usr/share/doc/"${PF}"/html/{Makefile*,Doxyfile*} || die
	fi

	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -name "*.a" -delete || die
}

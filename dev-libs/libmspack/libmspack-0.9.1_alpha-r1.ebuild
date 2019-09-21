# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/kyz/libmspack.git"
	inherit git-r3
	MY_P="${PN}-9999"
else
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86 ~x64-solaris"
	MY_PV="${PV/_alpha/alpha}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://www.cabextract.org.uk/libmspack/libmspack-${MY_PV}.tar.gz"
fi

DESCRIPTION="A library for Microsoft compression formats"
HOMEPAGE="https://www.cabextract.org.uk/libmspack/"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug doc static-libs"

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-fix-bigendian.patch )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		# Re-create file layout from release tarball
		pushd "${WORKDIR}" &>/dev/null || die
		cp -aL "${S}"/${PN} "${WORKDIR}"/${PN}-source || die
		rm -r "${S}" || die
		mv "${WORKDIR}"/${PN}-source "${S}" || die
		popd &>/dev/null || die
	fi

	default

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

multilib_src_test() {
	if multilib_is_native_abi; then
		default
		cd "${S}"/test && "${BUILD_DIR}"/test/cabd_test || die
	fi
}

multilib_src_install_all() {
	DOCS=(AUTHORS ChangeLog NEWS README TODO)
	use doc && HTML_DOCS=(doc/*)
	default_src_install
	if use doc; then
		rm "${ED%/}"/usr/share/doc/"${PF}"/html/{Makefile*,Doxyfile*} || die
	fi

	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}

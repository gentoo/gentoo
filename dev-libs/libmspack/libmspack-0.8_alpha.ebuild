# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools multilib-minimal

MY_PV="${PV/_alpha/alpha}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A library for Microsoft compression formats"
HOMEPAGE="https://www.cabextract.org.uk/libmspack/"
SRC_URI="https://www.cabextract.org.uk/libmspack/libmspack-${MY_PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc static-libs utils"

DEPEND=""
RDEPEND="
	utils? ( !app-arch/mscompress )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
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
	if ! use utils; then
		rm "${ED%/}"/usr/bin/* || die
	fi

	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}

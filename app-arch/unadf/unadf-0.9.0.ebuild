# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# autotools has automagic test building
# cmake has half baked installation
inherit autotools

MY_PN="ADFlib"

DESCRIPTION="Extract files from Amiga adf disk images"
HOMEPAGE="https://github.com/adflib/ADFlib/"
SRC_URI="
	https://github.com/adflib/ADFlib/archive/refs/tags/v${PV}.tar.gz
		-> ${MY_PN}-${PV}.tar.gz
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="|| ( GPL-2+ LGPL-2.1+ )"
SLOT="0/2" # see adflib_lt_version from configure.ac and util/bump_project_version for more details
KEYWORDS="amd64 ~hppa ppc x86"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-libs/check )"

PATCHES=( "${FILESDIR}"/unadf-0.9.0-make-test-build-conditional.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local detected_libtool_ver
	detected_libtool_ver="$(sed -n -e 's/m4_define(\[adflib_lt_version\],\[\([0-9]*\):[0-9]*:[0-9]*\])/\1/p' configure.ac)"
	if [[ "${SLOT}" != "0/${detected_libtool_ver}" ]]; then
		die "SLOT ${SLOT} doesn't match upstream specified libtool version ${detected_libtool_ver}."
	fi
	econf $(use_enable test tests) $(use_enable test regtests)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

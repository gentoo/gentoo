# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/google/google-authenticator-libpam.git"
	inherit git-r3
else
	SRC_URI="https://github.com/google/google-authenticator-libpam/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	S="${WORKDIR}/google-authenticator-libpam-${PV}"
fi

DESCRIPTION="PAM Module for two step verification via mobile platform"
HOMEPAGE="https://github.com/google/google-authenticator-libpam"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# We might want to use getpam_mod_dir from pam eclass,
	# but the build already appends "/security" for us.
	econf --libdir="/$(get_libdir)"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "For further information see"
		elog "https://wiki.gentoo.org/wiki/Google_Authenticator"
		elog ""
		elog "If you want support for QR-Codes, install media-gfx/qrencode."
	fi
}

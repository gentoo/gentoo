# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit multilib

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://github.com/google/${PN}.git"
	inherit git-r3 autotools
	S="${WORKDIR}/${P}/libpam"
else
	MY_P=${P%_pre*}
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	S="${WORKDIR}/${MY_P}"
fi

DESCRIPTION="PAM Module for two step verification via mobile platform"
HOMEPAGE="https://github.com/google/google-authenticator"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="virtual/pam"
RDEPEND="${DEPEND}"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
}

src_configure() {
	# We might want to use getpam_mod_dir from pam eclass,
	# but the build already appends "/security" for us.
	econf \
		--docdir="\$(datarootdir)/doc/${PF}" \
		--htmldir='$(docdir)/html' \
		--libdir="/$(get_libdir)"
}

src_compile() {
	default

	if [[ ${PV} == "9999" ]] ; then
		local stamp=$(date --date="$(git log -n1 --pretty=format:%ci master)" -u "+%Y%m%d%H%M%S")
		emake dist

		local otar=$(echo ${PN}-*.tar.gz)
		local ntar="${otar%.tar.gz}_pre${stamp}.tar.xz"
		zcat "${otar}" | xz > "${ntar}"
	fi
}

src_install() {
	default
	# Punt the pam module libtool archive.
	find "${ED}" -name '*.la' -delete
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "For further information see"
		elog "https://wiki.gentoo.org/wiki/Google_Authenticator"
		elog ""
		elog "If you want support for QR-Codes, install media-gfx/qrencode."
	fi
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/mgorny/google-authenticator-libpam-hardened.git"
inherit autotools git-r3

DESCRIPTION="PAM Module for two step verification via mobile platform"
HOMEPAGE="https://github.com/mgorny/google-authenticator-libpam-hardened"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+qrcode"

DEPEND="sys-auth/oath-toolkit:=
	sys-libs/pam
	qrcode? ( media-gfx/qrencode:= )"
RDEPEND="${DEPEND}
	!sys-auth/google-authenticator"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		# TODO: use getpam_mod_dir after fixing build system
		--libdir="/$(get_libdir)"

		$(use_enable qrcode qrencode)
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

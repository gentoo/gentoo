# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="A major mode for editing Erlang"
HOMEPAGE="https://www.erlang/
	https://github.com/erlang/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/erlang/otp.git"
	S="${WORKDIR}/${P}/lib/tools/emacs"
else
	# Distfile is shared with dev-lang/erlang.
	SRC_URI="https://github.com/erlang/otp/archive/OTP-${PV}.tar.gz
		-> erlang-${PV}.tar.gz"
	S="${WORKDIR}/otp-OTP-${PV}/lib/tools/emacs"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	!dev-lang/erlang[emacs(-)]
"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed -e "s:/usr/share:${EPREFIX}/usr/share:g" \
		"${FILESDIR}/${SITEFILE}" > "${T}/${SITEFILE}" || die
}

src_install() {
	elisp-install erlang *.el{,c}
	elisp-site-file-install "${T}/${SITEFILE}"
}

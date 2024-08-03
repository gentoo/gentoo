# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

# Distfile is shared with dev-lang/erlang.
DESCRIPTION="A major mode for editing Erlang"
HOMEPAGE="https://www.erlang. https://github.com/erlang/"
SRC_URI="https://github.com/erlang/otp/archive/OTP-${PV}.tar.gz -> erlang-${PV}.tar.gz"
S="${WORKDIR}"/otp-OTP-${PV}/lib/tools/emacs

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!dev-lang/erlang[emacs(-)]"

SITEFILE=50${PN}-gentoo.el

src_install() {
	elisp-install erlang *.el *.elc

	sed -e "s:/usr/share:${EPREFIX}/usr/share:g" \
		"${FILESDIR}"/${SITEFILE} > "${T}"/${SITEFILE} || die
	elisp-site-file-install "${T}"/${SITEFILE}
}

# Copyright 2018-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="A pass extension for managing one-time-password (OTP) tokens"
HOMEPAGE="https://github.com/tadfisher/pass-otp"
SRC_URI="https://github.com/tadfisher/pass-otp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-tcltk/expect:* )"

RDEPEND="
	>=app-admin/pass-1.7
	sys-auth/oath-toolkit
	media-gfx/qrencode
"

src_compile() {
	:
}

src_install() {
	emake install DESTDIR="${D}" BASHCOMPDIR="$(get_bashcompdir)"
}

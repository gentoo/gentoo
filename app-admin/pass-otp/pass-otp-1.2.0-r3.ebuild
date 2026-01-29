# Copyright 2018-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A pass extension for managing one-time-password (OTP) tokens"
HOMEPAGE="https://github.com/tadfisher/pass-otp"
SRC_URI="https://github.com/tadfisher/pass-otp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-tcltk/expect:* )"
# which dep can be dropped in >1.2.0
RDEPEND="
	>=app-admin/pass-1.7
	media-gfx/qrencode
	sys-auth/oath-toolkit
	sys-apps/which
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-bash-5.2.patch
)

src_compile() {
	:
}

src_install() {
	# BASHCOMPDIR intentionally omitted, see bug #767871
	emake install DESTDIR="${D}"
}

# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson systemd

DESCRIPTION="Minimal seat management daemon and universal library"
HOMEPAGE="https://sr.ht/~kennylevinsen/seatd"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/seatd"
else
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
	SRC_URI="https://git.sr.ht/~kennylevinsen/seatd/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
LICENSE="MIT"
SLOT="0/1"
IUSE="elogind systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"
BDEPEND=">=app-text/scdoc-1.9.7"

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		-Dwerror=false
	)

	if use elogind || use systemd; then
		emesonargs+=( -Dlogind=enabled )
	else
		emesonargs+=( -Dlogind=disabled )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install
	newinitd "${FILESDIR}/seatd.initd" seatd
	systemd_dounit contrib/systemd/seatd.service
}

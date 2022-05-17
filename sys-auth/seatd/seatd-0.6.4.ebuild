# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="Minimal seat management daemon and universal library"
HOMEPAGE="https://sr.ht/~kennylevinsen/seatd"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.sr.ht/~kennylevinsen/seatd"
else
	KEYWORDS="amd64 arm arm64 ppc64 ~riscv x86"
	SRC_URI="https://git.sr.ht/~kennylevinsen/seatd/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
LICENSE="MIT"
SLOT="0/1"
IUSE="builtin elogind +server systemd"
REQUIRED_USE="?? ( elogind systemd )"

DEPEND="
	elogind? ( sys-auth/elogind )
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}
	server? ( acct-group/seat )
"
BDEPEND=">=app-text/scdoc-1.9.7"

src_configure() {
	local emesonargs=(
		-Dman-pages=enabled
		$(meson_feature builtin libseat-builtin)
		$(meson_feature server)
	)

	if use elogind ; then
		emesonargs+=( -Dlibseat-logind=elogind )
	elif use systemd; then
		emesonargs+=( -Dlibseat-logind=systemd )
	else
		emesonargs+=( -Dlibseat-logind=disabled )
	fi

	meson_src_configure
}

src_install() {
	meson_src_install

	if use server; then
		newinitd "${FILESDIR}/seatd.initd" seatd
		systemd_dounit contrib/systemd/seatd.service
	fi
}

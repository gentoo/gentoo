# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils systemd

DESCRIPTION="Daemon for radeon-profile GUI"
HOMEPAGE="https://github.com/marazmista/radeon-profile-daemon"
if [[ "${PV}" == 99999999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/marazmista/radeon-profile-daemon.git"
else
	SRC_URI="https://github.com/marazmista/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	!<x11-apps/radeon-profile-20200504-r1
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-20190603-run_subdir.patch"
)

src_prepare() {
	eapply -p2 "${PATCHES[@]}"
	eapply_user

	sed \
		-e '/^bin\.path/s@/bin@/sbin@' \
		-e "/^service\.path/s@=.*\$@= $(systemd_get_systemunitdir)@" \
		-i radeon-profile-daemon.pro || die
	sed \
		-e '/^ExecStart/s@/bin/@/sbin/@' \
		-i extra/${PN}.service || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
}

pkg_postinst() {
	elog "Users need to be in the \"video\" group if they want to change"
	elog "video card settings via ${PN}"
}

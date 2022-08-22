# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="Postfix Sender Rewriting Scheme daemon"
HOMEPAGE="https://github.com/roehling/postsrsd"
SRC_URI="https://github.com/roehling/postsrsd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="sys-apps/help2man"

CHROOT_DIR="${EPREFIX}/var/lib/postsrsd"

src_configure() {
	local mycmakeargs=(
		-DCHROOT_DIR="${CHROOT_DIR}"

		# This doesn't affect functionality on OpenRC, it just
		# forces the build system to install the systemd units.
		-DINIT_FLAVOR="systemd"
		-DSYSD_UNIT_DIR="$(systemd_get_systemunitdir)"

		-DDOC_DIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/postsrsd.init-r2 postsrsd
	newconfd "${BUILD_DIR}"/postsrsd.default postsrsd
	keepdir "${CHROOT_DIR}"
}

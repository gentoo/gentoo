# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="Postfix Sender Rewriting Scheme daemon"
HOMEPAGE="https://github.com/roehling/postsrsd"
SRC_URI="https://github.com/roehling/postsrsd/archive/${PV}.tar.gz -> ${P}.tar.gz"

# See REUSE.toml; GPL-3 for the main software, BSD for src/sha*.
LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/confuse:="
DEPEND="
	${RDEPEND}
	test? (
		dev-libs/check
	)
"

CHROOT_DIR="${EPREFIX}/var/lib/postsrsd"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.11-docdir.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)

		-DPOSTSRSD_CHROOTDIR="${CHROOT_DIR}"
		-DSYSTEMD_UNITDIR="$(systemd_get_systemunitdir)"

		-DINSTALL_SYSTEMD_SERVICE=ON
		# https://github.com/roehling/postsrsd/blob/main/doc/packaging.rst#third-party-dependencies
		-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
		# We don't want to run tests with sanitizers. They're
		# unreliable under sandbox and don't run on all platforms
		-DTESTS_WITH_ASAN=OFF

		-DWITH_MILTER=OFF
		-DWITH_SQLITE=OFF
		-DWITH_REDIS=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/postsrsd.init-r2 postsrsd
	newconfd "${FILESDIR}"/postsrsd.confd postsrsd
	keepdir "${CHROOT_DIR}"
}

# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Secure Reliable Transport (SRT) library and tools"
HOMEPAGE="https://github.com/Haivision/srt"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Haivision/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Haivision/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv -sparc x86 ~ppc-macos ~x64-macos"
fi

LICENSE="MPL-2.0"
SLOT="0/1.4.3"
IUSE="gnutls"

RDEPEND="
	gnutls? (
		dev-libs/nettle:0=[${MULTILIB_USEDEP}]
		net-libs/gnutls:0=[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		dev-libs/openssl:0=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PV}-always-GNUInstallDirs.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=OFF
		-DUSE_GNUTLS=$(usex gnutls)
	)
	cmake-multilib_src_configure
}

multilib_src_install() {
	cmake_src_install
	# remove old upstream temporary compatibility pc
	rm "${ED}/usr/$(get_libdir)/pkgconfig/haisrt.pc" || die
}

# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils systemd

DESCRIPTION="A simple and lightweight fan control program"
HOMEPAGE="https://github.com/vmatare/thinkfan/"
SRC_URI="https://github.com/vmatare/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3+"
SLOT="0"
IUSE="atasmart nvml +yaml"

DEPEND="
	atasmart? ( dev-libs/libatasmart:= )
	yaml? ( dev-cpp/yaml-cpp:= )"

RDEPEND="
	${DEPEND}
	nvml? ( x11-drivers/nvidia-drivers )
"

src_prepare() {
	cmake-utils_src_prepare

	# Don't install license file
	# Don't use supplied init scripts
	# Fix QA warning for doc dir
	local mysedargs=(
		-e 's/COPYING//'
		-e 's/OPENRC_FOUND/DISABLE/g'
		-e 's/SYSTEMD_FOUND/DISABLE/g'
		-e "s/thinkfan)/${PF})/"
		-i CMakeLists.txt
	)

	sed "${mysedargs[@]}" || die
}

src_configure() {
	local mycmakeargs=(
		"-DCMAKE_BUILD_TYPE=Release"
		"-DUSE_ATASMART=$(usex atasmart)"
		"-DUSE_NVML=$(usex nvml)"
		"-DUSE_YAML=$(usex yaml)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	newinitd "${FILESDIR}"/thinkfan.initd thinkfan
	newconfd "${FILESDIR}"/thinkfan.confd thinkfan

	systemd_dounit "${FILESDIR}"/thinkfan.service "${FILESDIR}"/thinkfan-wakeup.service
}

pkg_postinst() {
	if use yaml; then
		einfo "Since you have enabled the 'yaml' use flag,"
		einfo "please keep in mind, that you need to convert"
		einfo "your old config file format the new yaml based config file format."
		einfo "See installed example yaml config file for more details."
	fi
}

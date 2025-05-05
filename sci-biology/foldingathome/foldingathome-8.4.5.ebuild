# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..13} )
inherit python-any-r1 scons-utils systemd

DESCRIPTION="Distributed computing project for simulating protein dynamics."
HOMEPAGE="https://foldingathome.org"
SRC_URI="
	https://github.com/FoldingAtHome/fah-client-bastet/archive/refs/tags/v${PV}.tar.gz
		-> foldingathome-client-v${PV}.tar.gz
	https://github.com/CauldronDevelopmentLLC/cbang/archive/refs/tags/bastet-v${PV}.tar.gz
		-> foldingathome-cbang-v${PV}.tar.gz
"
S="${WORKDIR}/fah-client-bastet-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="systemd video_cards_amdgpu video_cards_nvidia"

DEPEND="
	acct-group/foldingathome
	acct-user/foldingathome
	app-arch/bzip2
	app-arch/lz4
	dev-db/sqlite:3
	dev-libs/expat
	dev-libs/openssl
	sys-libs/zlib
	systemd? ( sys-apps/systemd )
	!systemd? ( !!sys-apps/systemd )
"

RDEPEND="
	${DEPEND}
	acct-group/video
	video_cards_amdgpu? ( dev-libs/rocm-opencl-runtime )
	video_cards_nvidia? ( dev-util/nvidia-cuda-toolkit )
"

src_compile() {
	export CBANG_HOME="${WORKDIR}/cbang-bastet-v${PV}"
	escons -C "${CBANG_HOME}"
	escons
}

src_install(){
	newbin fah-client foldingathome

	sed -i "s|fah-client|foldingathome|g" install/lin/fah-client.service || die

	systemd_newunit install/lin/fah-client.service foldingathome.service

	keepdir /var/log/foldingathome
	keepdir /var/lib/foldingathome

	fowners foldingathome:foldingathome /var/log/foldingathome/ /var/lib/foldingathome/

	keepdir /etc/foldingathome
	echo "<config/>" > "${ED}"/etc/foldingathome/config.xml || die
}

pkg_postinst() {
	einfo "Folding@Home comes with foldingathome.service"
	einfo "Please start/enable it then visit http://localhost:7396/ to manage it"
}

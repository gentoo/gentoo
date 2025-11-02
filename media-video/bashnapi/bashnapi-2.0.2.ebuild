# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=napi-v${PV}
DESCRIPTION="Napiprojekt.pl subtitle downloader in bash"
HOMEPAGE="https://gitlab.com/hesperos/napi/"
SRC_URI="
	https://gitlab.com/hesperos/napi/-/archive/v${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# tests are normally run via docker
RESTRICT="test"

RDEPEND="
	app-arch/p7zip
	net-misc/wget
	sys-apps/debianutils
	sys-apps/file
"

pkg_postinst() {
	# packages that can be used to detect FPS
	local fps_pkgs=(
		media-video/ffmpeg
		media-video/mediainfo
		media-video/mplayer
		# also mplayer2
	)
	local p found

	for p in "${fps_pkgs[@]}"; do
		if has_version "${p}"; then
			found=1
			break
		fi
	done

	if [[ ! ${found} ]]; then
		elog "In order to support FPS detection, install one of the following packages:"
		elog
		for p in "${fps_pkgs[@]}"; do
			elog "  ${p}"
		done
	fi
}

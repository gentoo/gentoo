# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Napiprojekt.pl subtitle downloader in bash"
HOMEPAGE="http://sourceforge.net/projects/bashnapi/"
SRC_URI="mirror://sourceforge/${PN}/bashnapi_v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# subotage is now integrated into bashnapi
RDEPEND="app-arch/p7zip
	!media-video/subotage"

S=${WORKDIR}/napi-${PV}

src_configure() {
	# install.sh does not support --destdir
	sed -i -e "s^\(NAPI_COMMON_PATH=\).*$^\1${EPREFIX}/usr/share/napi^" \
		napi.sh subotage.sh || die
}

src_install() {
	default # for docs
	dobin napi.sh subotage.sh
	insinto /usr/share/napi
	doins napi_common.sh
}

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

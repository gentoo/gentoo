# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QA_PKGCONFIG_VERSION=$(ver_cut 1-2)
inherit autotools ffmpeg-compat

DESCRIPTION="A libav/ffmpeg based source library for easy frame accurate access"
HOMEPAGE="https://github.com/FFMS/ffms2"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/FFMS/ffms2.git"
	inherit git-r3
else
	SRC_URI="https://github.com/FFMS/ffms2/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/ffms2-${PV}

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/4"

RDEPEND="
	media-video/ffmpeg-compat:6=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES="${FILESDIR}/${P}-Fix-build-with-ffmpeg-5.patch"

src_prepare() {
	default

	# Cheesy hack from autogen.sh
	mkdir src/config || die
	eautoreconf
}

src_configure() {
	# TODO: try using ffmpeg-7 w/o compat in >=ffmpegsource-5 (bug #948162)
	ffmpeg_compat_setup 6

	default

	sed -i -e "s|@FFMS_VERSION@|${PV}|g" \
		"${S}"/ffms2.pc.in || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

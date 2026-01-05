# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QA_PKGCONFIG_VERSION=$(ver_cut 1-2)
inherit autotools

DESCRIPTION="A libav/ffmpeg based source library for easy frame accurate access"
HOMEPAGE="https://github.com/FFMS/ffms2"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/FFMS/ffms2.git"
	inherit git-r3
else
	SRC_URI="https://github.com/FFMS/ffms2/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/ffms2-${PV}

	KEYWORDS="amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/5"

RDEPEND="
	>=media-video/ffmpeg-6.1:=
	virtual/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	# Cheesy hack from autogen.sh
	mkdir src/config || die
	eautoreconf
}

src_configure() {
	default

	sed -i -e "s|@FFMS_VERSION@|${PV}|g" \
		"${S}"/ffms2.pc.in || die
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}

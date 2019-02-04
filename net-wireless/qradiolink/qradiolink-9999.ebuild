# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Multimode SDR experimentation GUI for GNUradio"
HOMEPAGE="http://qradiolink.org"

LICENSE="GPL-3"
SLOT="0"
if [ "${PV}" = "9999" ]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kantooon/qradiolink.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/kantooon/qradiolink/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi
IUSE=""

DEPEND="dev-libs/libconfig[cxx]
	net-wireless/gnuradio:=[analog,audio,digital,fec,filter,qt5]
	net-wireless/gr-osmosdr:=
	dev-libs/boost:=
	dev-libs/protobuf:=
	media-libs/opus:=
	media-sound/pulseaudio
	media-libs/codec2:=
	media-sound/gsm:=
	media-libs/libjpeg-turbo:=
	media-libs/speexdsp:=
	dev-qt/qtwidgets:5=
	dev-qt/qtgui:5=
	dev-qt/qtnetwork:5=
	dev-qt/qtsql:5=
	dev-qt/qtcore:5=
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	eapply "${FILESDIR}/find-qwt.patch"
	cd ext/ || die
	protoc --cpp_out=. Mumble.proto
	protoc --cpp_out=. QRadioLink.proto
}

src_configure() {
	eqmake5
}

src_install() {
	dobin qradiolink
}

EAPI=8

DESCRIPTION="Peer-to-peer sharing for Gnutella, BitTorrent, magnet, and eD2k"
HOMEPAGE="https://github.com/nmatavka/hermes-wireshare"
SRC_URI="https://github.com/nmatavka/hermes-wireshare/releases/download/release/7.0/WireShare-7.0-source.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/hermes-wireshare-7.0"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-21"
RDEPEND=">=virtual/jre-21"
BDEPEND="dev-java/gradle-bin"

src_compile() {
	./gradlew --no-daemon wireShareJar
}

src_install() {
	dobin packaging/common/launchers/WireShare
	insinto /usr/share/wireshare
	doins WireShare.jar
	doicon -s scalable packaging/common/icons/scalable/apps/cx.hermes.WireShare.svg
	doicon -s scalable packaging/common/icons/scalable/status/cx.hermes.WireShare.XferDone.svg
	for size in 16 20 22 24 32 36 40 48 64 72 96 128 192 256 384 512 1024; do
		newicon -s "${size}" "packaging/common/icons/hicolor/${size}x${size}/apps/cx.hermes.WireShare.png" cx.hermes.WireShare.png
		insinto /usr/share/icons/hicolor/${size}x${size}/status
		newins "packaging/common/icons/hicolor/${size}x${size}/status/cx.hermes.WireShare.XferDone.png" cx.hermes.WireShare.XferDone.png
	done
	domenu packaging/common/app/cx.hermes.WireShare.desktop
	insinto /usr/share/metainfo
	doins packaging/common/app/cx.hermes.WireShare.metainfo.xml
}

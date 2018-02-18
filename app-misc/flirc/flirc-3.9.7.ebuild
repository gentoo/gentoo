EAPI=6

inherit eutils unpacker

DESCRIPTION="Flirc allows you to pair any remote control with your computer or media center."
HOMEPAGE="https://flirc.tv/"
SRC_URI="https://packagecloud.io/Flirc/repo/packages/ubuntu/zesty/flirc_${PV}_amd64.deb/download.deb -> ${P}.deb"
LICENSE="FLIRC"
SLOT="0"
KEYWORDS="amd64"
IUSE="headless"

RESTRICT="bindist mirror strip"

S="${WORKDIR}"

RDEPEND="dev-libs/libusb
	dev-libs/hidapi
	!headless? (
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtgui:5
		dev-qt/qtxml:5
		dev-qt/qtxmlpatterns:5
		dev-qt/qtnetwork:5
		dev-qt/qtcore:5 )"


src_prepare () {
	if ! use headless ; then
		sed -i -e 's/^Version=.*$/Version=1.0/' "${S}"/usr/share/applications/Flirc.desktop
	fi
	eapply_user
}

src_install () {
	insinto /lib/udev/rules.d
	newins etc/udev/rules.d/99-flirc.rules 51-flirc.rules
	doman usr/share/doc/flirc/flirc_util.1
	exeinto /opt/bin
	doexe usr/bin/flirc_util
	if ! use headless ; then
		doman usr/share/doc/flirc/Flirc.1
		exeinto /opt/bin
		doexe usr/bin/Flirc
		insinto /usr/share/pixmaps
		doins usr/share/pixmaps/Flirc.png
		insinto /usr/share/applications
		doins usr/share/applications/Flirc.desktop
	fi
}

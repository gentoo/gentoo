# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Cross Platform file manager"
HOMEPAGE="http://doublecmd.sourceforge.net/"
SRC_URI="https://github.com/doublecmd/doublecmd/releases/download/v${PV}/doublecmd-${PV}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip" #FreePascal does the stripping on its own.

ABBREV="doublecmd"

DEPEND="
	>=dev-qt/qtcore-5.6
	>=dev-qt/qtgui-5.6
	>=dev-qt/qtnetwork-5.6
	>=dev-qt/qtx11extras-5.6
	dev-libs/libqt5pas:0/2.2"
BDEPEND="
	dev-lang/lazarus:0/2.2
	net-misc/rsync"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	dev-libs/glib
	x11-libs/libX11"

S="${WORKDIR}/${ABBREV}-${PV}"

src_prepare() {
	default
	use amd64 && export CPU_TARGET="x86_64" || export CPU_TARGET="i386"
	export lazpath="${EPREFIX}/usr/share/lazarus"
	find ./ -type f -name "build.sh" -exec sed -i 's#$lazbuild #$lazbuild --lazarusdir=${lazpath} #g' {} \; || die
}

src_compile() {
	./build.sh release qt5 || die "build.sh failed"
}

src_install() {
	install/linux/install.sh --install-prefix=build || die "install.sh failed"

	# Since we're installing a polkit action, let's utilize it. For extra fanciness.
	printf "\nActions=StartAsRoot;\n\n[Desktop Action StartAsRoot]\nExec=/usr/bin/pkexec ${EPREFIX}/usr/bin/doublecmd\nName=Start as root\n" >> \
		${S}/build/usr/share/applications/${ABBREV}.desktop || die

	# Without the following, the .desktop file doesn't show up in the KDE menu, specifically under the Utility category.
	# Can't figure out why, but you're welcome to try. Absurdly, it works fine in any other category.
	mv "${S}/build/usr/share/applications/${ABBREV}.desktop" "${S}/build/usr/share/applications/${ABBREV}-${PN}.desktop" || die

	#using rsync to speed things up.
	rsync -a "${S}/build/" "${D}/" || die "Unable to copy files"
	dosym ../$(get_libdir)/${ABBREV}/${ABBREV} /usr/bin/${ABBREV}
}

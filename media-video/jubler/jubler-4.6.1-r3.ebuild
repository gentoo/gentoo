# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/jubler/jubler-4.6.1-r3.ebuild,v 1.11 2014/07/09 07:40:33 ercpe Exp $

EAPI="2"
WANT_ANT_TASKS="ant-nodeps ant-contrib"
inherit fdo-mime eutils java-pkg-2 java-ant-2 toolchain-funcs

MY_PN=${PN/#j/J}
DESCRIPTION="Java subtitle editor"
HOMEPAGE="http://www.jubler.org/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_PN}-source-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mplayer nls spell"

RDEPEND=">=virtual/jre-1.5
	virtual/ffmpeg
	mplayer? ( media-video/mplayer[libass] )
	spell? (
		app-text/aspell
		>=dev-java/zemberek-2.0[linguas_tr]
	)"

DEPEND=">=virtual/jdk-1.5
	virtual/ffmpeg
	app-text/xmlto
	>=dev-java/jupidator-0.6.0
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_PN}-${PV}

src_unpack() {
	unpack ${A}
	cp "${FILESDIR}"/update-${PV}.xml "${S}" || die
}

java_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-ffmpeg-1.patch
	epatch "${FILESDIR}"/${P}-ffmpeg-2.patch
	chmod +x resources/installers/linux/iconinstall
	#cd resources/libs || die
	java-pkg_jarfrom --build-only --into resources/libs jupidator
	rm -R plugins/{autoupdate,macapp} || die "unneeded plugin cleanup failed"
	rm -R resources/libs/ant-contrib || die "jar cleanup failed"
	if ! use mplayer; then
		rm -R plugins/mplayer || die "mplayer plugin removal failed"
	fi
	if ! use spell; then
		rm -R plugins/{zemberek,aspell} || die "spellcheck plugin removal failed"
	fi
	sed -i -e "s/CODEC_TYPE/AVMEDIA_TYPE/g" $(find resources/ffmpeg/ffdecode -name "*.c")
	sed -i -e "s:PKT_FLAG_KEY:AV_PKT_FLAG_KEY:g" $(find resources/ffmpeg/ffdecode -name "*.c")
}

src_compile() {
	java-pkg_filter-compiler ecj-3.2
	ANT_TASKS="ant-nodeps ant-contrib" eant $(use nls && echo allparts) $(use nls || echo parts) help changelog || die "eant failed"
	#cp -v dist/help/jubler-faq.html build/classes/help || die "cp failed"
	cd resources/ffmpeg/ffdecode || die
	CC=$(tc-getCC) NOSTRIP=true emake linuxdyn || die "make failed"
}

src_install() {
	java-pkg_dojar dist/Jubler.jar
	use nls && java-pkg_dojar dist/i18n/*.jar
	insinto /usr/share/jubler/lib/lib
	doins dist/lib/*.jar  || die "Plugin installation failed"
	#java-pkg_dojar dist/lib/*.jar
	use spell && java-pkg_register-dependency zemberek zemberek2-cekirdek.jar
	use spell && java-pkg_register-dependency zemberek zemberek2-tr.jar
	java-pkg_doso resources/ffmpeg/ffdecode/libffdecode.so
	doicon resources/installers/linux/jubler.png
	domenu resources/installers/linux/jubler.desktop

	DESTDIR="${D}" eant linuxdesktopintegration
	rm -vr "${D}/usr/share/menu" || die

	java-pkg_dolauncher jubler --main Jubler
	dohtml ChangeLog.html || die "dohtml failed"
	dodoc README || die "dodoc failed"
	doman resources/installers/linux/jubler.1 || die "doman fialed"
	insinto /usr/share/jubler/help
	doins dist/help/* || die "doins failed"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}

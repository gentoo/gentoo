# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

DESCRIPTION="Wallpapers featuring Gentoo mascot Larry the cow"
HOMEPAGE="http://www.gentoo.org/main/en/graphics.xml#wallpapers"
web_home='http://www.gentoo.org/images/backgrounds'
SRC_URI="
	${web_home}/gentoo-abducted-800x600.png
	${web_home}/gentoo-abducted-1024x768.png
	${web_home}/gentoo-abducted-1152x864.png
	${web_home}/gentoo-abducted-1280x1024.png
	${web_home}/gentoo-abducted-1600x1200.png
	${web_home}/gentoo-abducted-1680x1050.png
	${web_home}/larry-cave-cow-1024x768.jpg
	${web_home}/larry-cave-cow-1152x864.jpg
	${web_home}/larry-cave-cow-1280x1024.jpg
	${web_home}/larry-cave-cow-1600x1200.jpg
	${web_home}/gentoo-larry-bg-4:3.svg
	${web_home}/gentoo-larry-bg-5:4.svg
	${web_home}/gentoo-larry-bg-8:5.svg
	${web_home}/gentoo-larry-bg-16:9.svg
	${web_home}/gentoo-larry-bg-800x600.png
	${web_home}/gentoo-larry-bg-1024x768.png
	${web_home}/gentoo-larry-bg-1152x864.png
	${web_home}/gentoo-larry-bg-1280x720.png
	${web_home}/gentoo-larry-bg-1280x800.png
	${web_home}/gentoo-larry-bg-1280x960.png
	${web_home}/gentoo-larry-bg-1280x1024.png
	${web_home}/gentoo-larry-bg-1366x768.png
	${web_home}/gentoo-larry-bg-1440x900.png
	${web_home}/gentoo-larry-bg-1600x900.png
	${web_home}/gentoo-larry-bg-1600x1200.png
	${web_home}/gentoo-larry-bg-1680x1050.png
	${web_home}/gentoo-larry-bg-1920x1080.png
	${web_home}/gentoo-larry-bg-1920x1200.png
"

LICENSE="CC-BY-SA-2.5 CC-BY-NC-SA-2.5"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="mirror"  # TODO make a tarball, instead?

src_unpack() { :; }

src_install() {
	local backdrops='/usr/share/xfce4/backdrops'
	local share_home='backgrounds/larry-the-cow'

	insinto /usr/share/${share_home}/
	( cd "${DISTDIR}" && doins ${A} ) || die

	# Integrate with KDE 4
	dosym ../${share_home} /usr/share/wallpapers/larry-the-cow || die

	# Integrate with XFCE 4
	dodir ${backdrops}/ || die
	dosym ../../${share_home}/gentoo-abducted-1600x1200.png ${backdrops}/gentoo-abducted-4:3.png || die
	dosym ../../${share_home}/gentoo-abducted-1280x1024.png ${backdrops}/gentoo-abducted-5:4.png || die
	dosym ../../${share_home}/gentoo-abducted-1680x1050.png ${backdrops}/gentoo-abducted-8:5.png || die
	dosym ../../${share_home}/larry-cave-cow-1600x1200.jpg ${backdrops}/larry-cave-cow-4:3.jpg || die
	dosym ../../${share_home}/larry-cave-cow-1280x1024.jpg ${backdrops}/larry-cave-cow-5:4.jpg || die
	for ratio in 4:3 5:4 8:5 16:9 ; do
		dosym ../../${share_home}/gentoo-larry-bg-${ratio}.svg ${backdrops}/gentoo-larry-bg-${ratio}.svg || die
	done
}

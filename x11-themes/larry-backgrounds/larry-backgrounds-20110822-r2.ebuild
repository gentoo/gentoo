# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

web_home="https://www.gentoo.org/assets/img/wallpaper"

DESCRIPTION="Wallpapers featuring Gentoo mascot Larry the cow"
HOMEPAGE="https://www.gentoo.org/main/en/graphics.xml#wallpapers"
SRC_URI="
	${web_home}/abducted/gentoo-abducted-800x600.png
	${web_home}/abducted/gentoo-abducted-1024x768.png
	${web_home}/abducted/gentoo-abducted-1152x864.png
	${web_home}/abducted/gentoo-abducted-1280x1024.png
	${web_home}/abducted/gentoo-abducted-1600x1200.png
	${web_home}/abducted/gentoo-abducted-1680x1050.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake.svg
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1280x1024.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-800x600.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1024x768.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1152x864.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1280x960.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1600x1200.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1280x800.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1440x900.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1680x1050.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1920x1200.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1280x720.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1366x768.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1600x900.png
	${web_home}/gentoo-cow/gentoo-cow-gdm-remake-1920x1080.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-4-3.svg
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-5-4.svg
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-16-9.svg
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-16-10.svg
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-800x600.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1024x768.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1152x864.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1280x720.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1280x800.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1280x960.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1280x1024.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1366x768.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1440x900.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1600x900.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1600x1200.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1680x1050.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1920x1080.png
	${web_home}/gentoo-larry-bg/gentoo-larry-bg-1920x1200.png"
S="${WORKDIR}"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="mirror"  # TODO make a tarball, instead?

src_unpack() { :; }

src_install() {
	local backdrops='/usr/share/xfce4/backdrops'
	local share_home='backgrounds/larry-the-cow'

	cd "${DISTDIR}" || die
	insinto /usr/share/${share_home}/
	doins ${A}

	# Integrate with KDE 4
	dosym ../${share_home} /usr/share/wallpapers/larry-the-cow

	# Integrate with XFCE 4
	dodir ${backdrops}/
	dosym ../../${share_home}/gentoo-abducted-1600x1200.png ${backdrops}/gentoo-abducted-4:3.png
	dosym ../../${share_home}/gentoo-abducted-1280x1024.png ${backdrops}/gentoo-abducted-5:4.png
	dosym ../../${share_home}/gentoo-abducted-1680x1050.png ${backdrops}/gentoo-abducted-8:5.png
	dosym ../../${share_home}/gentoo-cow-gdm-remake-1600x1200.png ${backdrops}/gentoo-cow-gdm-remake-4:3.png
	dosym ../../${share_home}/gentoo-cow-gdm-remake-1280x1024.png ${backdrops}/gentoo-cow-gdm-remake-5:4.png
	dosym ../../${share_home}/gentoo-cow-gdm-remake-1680x1050.png ${backdrops}/gentoo-cow-gdm-remake-8:5.png
	local ratio
	for ratio in 4-3 5-4 16-9 16-10 ; do
		dosym ../../${share_home}/gentoo-larry-bg-${ratio}.svg ${backdrops}/gentoo-larry-bg-${ratio/-/:}.svg
	done
}

# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/unetbootin/unetbootin-608.ebuild,v 1.5 2014/11/02 14:14:49 jer Exp $

EAPI=5

inherit eutils qt4-r2

DESCRIPTION="Universal Netboot Installer creates Live USB systems for various OS distributions"
HOMEPAGE="http://unetbootin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""

UNBI_LINGUAS="
	am ar ast be bg bn ca cs da de el eo es et eu fa fi fo fr gl he hr hu id it
	ja lt lv ml ms nan nb nl nn pl pt_BR pt ro ru si sk sl sr sv sw tr uk ur vi
	zh_CN zh_TW
"

for lingua in ${UNBI_LINGUAS}; do
	IUSE="${IUSE} linguas_${lingua}"
done

S="${WORKDIR}"

DEPEND="dev-qt/qtgui:4"
RDEPEND="
	${DEPEND}
	app-arch/p7zip
	sys-boot/syslinux
	sys-fs/mtools
"

src_prepare() {
	epatch "${FILESDIR}/${PN}-581-desktop.patch"

	# QA check in case linguas are added or removed
	enum() {
		echo ${#}
	}
	[[ $(enum ${UNBI_LINGUAS}) -eq $(( $(enum $(echo ${PN}_*.ts) ) -1 )) ]] \
		|| die "Numbers of recorded and actual linguas do not match"
	unset enum

	# Make room between the last line of TRANSLATIONS and the next definition
	sed -i \
		-e '/^DEFINES/s|.*|\n&|g' \
		${PN}.pro || die

	# Remove localisations
	local lingua
	for lingua in ${UNBI_LINGUAS}; do
		if ! use linguas_${lingua}; then
			sed -i ${PN}.pro -e "/\.*${PN}_${lingua}\.ts.*/d" || die
			rm ${PN}_${lingua}.ts || die
		fi
	done
}

src_configure() {
	lupdate ${PN}.pro || die
	lrelease ${PN}.pro || die
	eqmake4 ${PN}.pro || die
}

src_install() {
	dobin ${PN}

	domenu ${PN}.desktop

	for file in ${PN}*.png; do
		size="${file/${PN}_}"
		size="${size/.png}x${size/.png}"
		insinto /usr/share/icons/hicolor/${size}/apps
		newins ${file} ${PN}.png
	done

	local lingua
	for lingua in ${UNBI_LINGUAS}; do
		if use linguas_${lingua}; then
			insinto /usr/share/${PN}
			doins ${PN}_${lingua}.qm
		fi
	done
}

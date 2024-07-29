# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic qmake-utils xdg-utils toolchain-funcs

DESCRIPTION="UNetbootin installs Linux/BSD distributions to a partition or USB drive"
HOMEPAGE="https://github.com/unetbootin/unetbootin"
SRC_URI="https://github.com/unetbootin/unetbootin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

UNBI_LINGUAS="
	am ar ast be bg bn ca cs da de el eo es et eu fa fi fo fr gl he hr hu id it
	ja lt lv ml ms nan nb nl nn pl pt_BR pt ro ru si sk sl sr sv sw tr uk ur vi
	zh_CN zh_TW
"

for lingua in ${UNBI_LINGUAS}; do
	IUSE="${IUSE} l10n_${lingua/_/-}"
done

S=${WORKDIR}/${P}/src/${PN}

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	app-arch/p7zip
	sys-boot/syslinux
	sys-fs/mtools
"

PATCHES=( "${FILESDIR}"/${PN}-675-desktop.patch )

src_prepare() {
	default

	# QA check in case linguas are added or removed
	enum() {
		echo ${#}
	}
	[[ $(enum ${UNBI_LINGUAS}) -eq $(( $(enum $(echo ${PN}_*.ts) ) -1 )) ]] \
		|| die "Numbers of recorded and actual linguas do not match"
	unset enum

	# Remove localisations
	local lingua
	for lingua in ${UNBI_LINGUAS}; do
		if ! use l10n_${lingua/_/-}; then
			sed -i ${PN}.pro -e "/\.*${PN}_${lingua}\.ts.*/d" || die
			rm ${PN}_${lingua}.ts || die
		fi
	done

	sed -i -e '/^RESOURCES/d' unetbootin.pro || die

	append-cflags -DNOSTATIC
	append-cxxflags -DNOSTATIC
}

src_configure() {
	export QMAKE_CXX="$(tc-getCXX)"

	"$(qt5_get_bindir)/"lrelease ${PN}.pro || die

	eqmake5
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
		if use l10n_${lingua/_/-}; then
			insinto /usr/share/${PN}
			doins ${PN}_${lingua}.qm
		fi
	done
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

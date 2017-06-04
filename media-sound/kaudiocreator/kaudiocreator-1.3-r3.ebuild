# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_LINGUAS="af ar be bg br bs ca ca@valencia cs cy da de el en_GB eo es et eu
fa fi fr ga gl hi hne hr is it ja kk km lt lv mai mk ms nb nds ne nl nn oc pa
pl pt_BR pt ro ru se sk sl sr@ijekavianlatin sr@ijekavian sr@Latn sr sv ta tg
th tr ug uk xh zh_CN zh_HK zh_TW"
inherit kde4-base

DESCRIPTION="CD ripper and audio encoder frontend based on KDE Frameworks"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=107645"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/107645-${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep libkcddb)
	$(add_kdeapps_dep libkcompactdisc)
	media-libs/libdiscid
	>=media-libs/taglib-1.5
"
RDEPEND="${DEPEND}
	kde-frameworks/kdelibs:4[udev,udisks(+)]
	$(add_kdeapps_dep audiocd-kio)
"

DOCS=( Changelog TODO )

pkg_postinst() {
	local stcnt=0

	has_version media-libs/flac && stcnt=$((stcnt+1))
	has_version media-sound/lame && stcnt=$((stcnt+1))
	has_version media-sound/vorbis-tools && stcnt=$((stcnt+1))

	if [[ ${stcnt} -lt 1 ]] ; then
		ewarn "You should emerge at least one of the following packages"
		ewarn "for ${PN} to do anything useful."
	fi
	elog "Optional runtime dependencies:"
	elog "FLAC - media-libs/flac"
	elog "MP3  - media-sound/lame"
	elog "OGG  - media-sound/vorbis-tools"

	kde4-base_pkg_postinst
}

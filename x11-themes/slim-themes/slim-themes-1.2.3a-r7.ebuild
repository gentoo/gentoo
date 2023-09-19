# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="SLiM (Simple Login Manager) themes pack"
HOMEPAGE="https://sourceforge.net/projects/slim.berlios/"
SRC_URI="
	mirror://sourceforge/project/slim.berlios/slim-1.2.3-themepack1a.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-gentoo-simple.tar.bz2
	mirror://gentoo/slim-archlinux.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-debian-moreblue.tar.bz2
	mirror://sourceforge/project/slim.berlios/slim-fingerprint.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-flat.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-lunar-0.4.tar.bz2
	mirror://sourceforge/project/slim.berlios/slim-previous.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-rainbow.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-rear-window.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-scotland-road.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-subway.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-wave.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-zenwalk.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-archlinux-simple.tar.gz
	mirror://sourceforge/project/slim.berlios/slim-lake.tar.gz
	mirror://gentoo/slim-gentoo-1.0.tar.bz2
	http://www.xfce-look.org/CONTENT/content-files/48605-xfce-g-box-slim-0.1.tar.gz
	http://www.konstantinhansen.de/source/slim_themes/gentoo_10_purple/gentoo_10_purple.tar.bz2 -> gentoo_10_purple-r1.tar.bz2
	http://www.konstantinhansen.de/source/slim_themes/gentoo_10_blue/gentoo_10_blue.tar.bz2 -> gentoo_10_blue-r1.tar.bz2
	http://www.konstantinhansen.de/source/slim_themes/gentoo_10_dark/gentoo_10_dark.tar.bz2 -> gentoo_10_dark-r1.tar.bz2
"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~mips ppc ppc64 ~riscv sparc x86"

RDEPEND="x11-misc/slim"

RESTRICT="strip binchecks"

PATCHES=(
	"${FILESDIR}/slim-theme-flat.patch"
)

src_install() {
	for i in capernoited flower2 gentoo isolated lotus-{sage,midnight} \
		mindlock slim-archlinux subway xfce-g-box Zenwalk ; do
			rm ${i}/README || die "rm README"
	done

	rm debian-moreblue/COPY* lotus-{sage,midnight}/{LICENSE*,COPY*} \
		parallel-dimensions/{LICENSE*,COPY*} xfce-g-box/COPYRIGHT.panel \
		|| die "rm LICENSE"

	local themesdir="/usr/share/slim/themes"
	insinto ${themesdir}
	doins -r .
}

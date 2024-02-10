# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=BashBurn-${PV}

DESCRIPTION="A shell script for burning optical media"
HOMEPAGE="http://bashburn.dose.se/ https://gitlab.com/anders.linden/BashBurn"
SRC_URI="http://bashburn.dose.se/index.php?s=file_download&id=25 -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"

BDEPEND="app-shells/bash"
RDEPEND="
	app-cdr/cdrtools
	app-shells/bash
	app-cdr/cdrdao
	app-cdr/dvd+rw-tools
	media-libs/flac
	|| ( dev-libs/libcdio-paranoia media-sound/cdparanoia )
	media-sound/lame
	|| ( media-sound/mpg123 media-sound/mpg321 )
	media-sound/normalize
	media-sound/vorbis-tools
	sys-apps/util-linux
"

src_prepare() {
	default

	# Fix for "warning: jobserver unavailable: using -j1."
	sed -i -e 's:make -C:$(MAKE) -C:' Makefile || die

	# Don't compress man pages, bug #732894
	sed -i -e "/gzip/d" Install.sh || die
}

src_install() {
	./Install.sh --prefix="${ED}"/usr || die

	# Remove /var/tmp/portage from installed script
	sed -i \
		-e "/BBROOTDIR=/s:'.*':'/usr/lib/Bashburn/lib':" \
		"${ED}"/usr/lib/Bashburn/lib/BashBurn.sh || die

	doman bashburn_man/bashburn.1

	rm -rf "${ED}"/usr/lib/Bashburn/lib/docs || die
	dodoc docs/{ChangeLog,CREDITS,FAQ,HOWTO,README,TODO,TRANSLATION_RULE}
}

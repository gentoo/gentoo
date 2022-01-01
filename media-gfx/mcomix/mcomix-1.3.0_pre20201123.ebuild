# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
inherit desktop python-r1 xdg

# Hash used for this version
GIT_PV="cdcb27533dc7ee2ebf7b0a8ab5ba10e61c0b8ff8"

DESCRIPTION="GTK image viewer for comic book archives"
HOMEPAGE="https://github.com/multiSnow/mcomix3"
SRC_URI="https://github.com/multiSnow/mcomix3/archive/${GIT_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	virtual/jpeg
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	!media-gfx/comix"
BDEPEND="sys-devel/gettext"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/mcomix3-${GIT_PV}

src_prepare() {
	default

	for file in mcomix/mcomix/messages/*/LC_MESSAGES/*po
	do
		msgfmt ${file} -o ${file/po/mo} || die
		rm ${file} || die
	done
}

src_install() {
	python_foreach_impl python_domodule mcomix/mcomix
	python_foreach_impl python_newscript mcomix/mcomixstarter.py mcomix

	for size in 16 22 24 32 48
	do
		doicon -s ${size} \
			mime/icons/${size}x${size}/*png \
			mcomix/mcomix/images/${size}x${size}/mcomix.png
	done
	doicon mcomix/mcomix/images/mcomix.png
	domenu mime/mcomix.desktop
	doman man/mcomix.1

	insinto /usr/share/metainfo
	doins mime/mcomix.appdata.xml

	dodoc README.rst TODO
}

pkg_postinst() {
	xdg_pkg_postinst
	echo
	elog "Additional packages are required to open the most common comic archives:"
	elog
	elog "    cbr: app-arch/unrar"
	elog "    cbz: app-arch/unzip"
	elog
	elog "You can also add support for 7z or LHA archives by installing"
	elog "app-arch/p7zip or app-arch/lha. Install app-text/mupdf for"
	elog "pdf support."
	echo
}

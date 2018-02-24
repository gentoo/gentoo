# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Scanner Access Now Easy"
HOMEPAGE="http://www.sane-project.org"
SRC_URI="ftp://ftp.sane-project.org/pub/sane/${P}/${P}.tar.gz
	ftp://ftp.sane-project.org/pub/sane/old-versions/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 sparc ~x86"
IUSE="gimp"

RDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	media-gfx/sane-backends
	gimp? ( media-gfx/gimp:2 )
"

DOCS=( AUTHORS Changelog NEWS PROBLEMS README )

PATCHES=( "${FILESDIR}/MissingCapsFlag.patch" )

src_configure() {
	econf \
		--datadir=/usr/share/misc \
		$(use_enable gimp)
}

src_install() {
	local gimpplugindir
	local gimptool
	emake DESTDIR="${D}" install
	if use gimp; then
		for gimptool in gimptool gimptool-2.0; do
			if [[ -x /usr/bin/${gimptool} ]]; then
				einfo "Setting plugin link for GIMP version	$(/usr/bin/${gimptool} --version)"
				gimpplugindir=$(/usr/bin/${gimptool} --gimpplugindir)/plug-ins
				break
			fi
		done
		if [[ "/plug-ins" != "${gimpplugindir}" ]]; then
			dodir ${gimpplugindir}
			dosym xscanimage ${gimpplugindir}/xscanimage
		else
			ewarn "No idea where to find the gimp plugin directory"
		fi
	fi
	einstalldocs
}

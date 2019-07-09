# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Open Clip Art Library (openclipart.org)"
HOMEPAGE="https://www.openclipart.org/"
SRC_URI="http://download.openclipart.org/downloads/${PV}/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="svg png gzip"

# suggested basedir for cliparts
CLIPART="/usr/share/clipart/${PN}"

src_compile() {
	local removeext=( $(usev !png) $(usev !svg) )
	[[ -z ${removeext} ]] && elog "No image formats specified - defaulting to all (png and svg)"

	local i
	for i in "${removeext[@]}"; do
		elog "Removing ${i} files..."
		find -name "*.${i}" -delete || die "Failed removing files (${i})"
	done

	if use gzip; then
		einfo "Compressing SVG files..."

		while IFS="" read -d $'\0' -r i ; do
			gzip -9c "${i}" >"${i}z" || die "Failed compressing ${i}"
			rm -f "${i}" || die "Failed removing temporary ${i}"
		done < <(find "${S}" -name "*.svg" -print0)
	fi
}

src_install() {
	insinto ${CLIPART}
	doins -r .
}

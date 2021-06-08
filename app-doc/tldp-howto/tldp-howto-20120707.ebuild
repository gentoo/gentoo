# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Linux Documentation Project HOWTOs"
HOMEPAGE="http://www.tldp.org"

MY_SRC="http://www.ibiblio.org/pub/Linux/docs/HOWTO"
SRC_URI="
	html? ( ${MY_SRC}/other-formats/html/Linux-html-HOWTOs-${PV}.tar.bz2 )
	htmlsingle? ( ${MY_SRC}/other-formats/html_single/Linux-html-single-HOWTOs-${PV}.tar.bz2 )
	pdf? ( ${MY_SRC}/other-formats/pdf/Linux-pdf-HOWTOs-${PV}.tar.bz2 )
	text? ( ${MY_SRC}/Linux-HOWTOs-${PV}.tar.bz2 )"

LICENSE="FDL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="+html htmlsingle pdf text"
REQUIRED_USE="|| ( html htmlsingle pdf text )"

RESTRICT="binchecks strip"

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die

	if use html; then
		unpack Linux-html-HOWTOs-${PV}.tar.bz2

		# for some reason this bundles the pdfs - older versions didn't
		if [[ -d "${S}"/HOWTO/pdf ]] ; then
			rm -r "${S}"/HOWTO/pdf || die
		fi

		# stray bin file, doubt anyone will ever need it
		rm -f "${S}"/HOWTO/RedHat-CD-HOWTO/rhcd-scripts/rvc || die
		mv "${S}"/HOWTO "${S}"/html || die
	fi

	if use htmlsingle; then
		mkdir "${S}"/htmlsingle || die
		pushd "${S}"/htmlsingle > /dev/null || die

		unpack Linux-html-single-HOWTOs-${PV}.tar.bz2

		popd > /dev/null || die
	fi

	if use pdf; then
		mkdir "${S}"/pdf || die
		pushd "${S}"/pdf > /dev/null || die

		unpack Linux-pdf-HOWTOs-${PV}.tar.bz2

		popd > /dev/null || die
	fi

	if use text; then
		mkdir "${S}"/text || die
		pushd "${S}"/text > /dev/null || die

		unpack Linux-HOWTOs-${PV}.tar.bz2

		popd > /dev/null || die
	fi
}

src_install() {
	dodoc -r "${S}"/*
}

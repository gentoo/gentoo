# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/icm/icm-3.7.3b.ebuild,v 1.6 2015/06/14 18:06:29 ulm Exp $

EAPI="5"

inherit eutils unpacker versionator

MY_PV=$(replace_version_separator 2 '-' )
MY_P="$PN-${MY_PV}"

DESCRIPTION="MolSoft LCC ICM Pro"
HOMEPAGE="http://www.molsoft.com/icm_pro.html"
SRC_URI="${MY_P}-linux.sh"

LICENSE="MolSoft"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="32bit 64bit vim-syntax"

REQUIRED_USE="^^ (
					( !32bit 64bit )
					( 32bit !64bit )
					( 32bit 64bit )
		)"

RESTRICT="fetch"

DEPEND="!sci-chemistry/icm-browser
		app-arch/unzip
		vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
		amd64? (
			64bit? (
					=media-libs/tiff-3*
					media-libs/libmng
					app-crypt/mit-krb5
					app-arch/bzip2
					media-libs/libpng:1.2
					|| ( virtual/jpeg:62 media-libs/jpeg:62 )
					x11-libs/libdrm
					x11-libs/libX11
					sys-apps/keyutils
			)
			32bit? (
					virtual/libstdc++:3.3
					>=x11-libs/libX11-1.6.2[abi_x86_32(-)]
			)
		)
		x86? (
				=media-libs/tiff-3*
				media-libs/libpng:1.2
				media-libs/libmng
				app-crypt/mit-krb5
				app-arch/bzip2
				x11-libs/libdrm
				x11-libs/libX11
				sys-apps/keyutils
		)"
RDEPEND="$DEPEND"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${SRC_URI} from "
	einfo "${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
}

src_unpack() {
	unpack_makeself
	unpack ./data.tgz
	rm ./data.tgz
}

src_install () {
	instdir=/opt/icm
	dodir "${instdir}"
	dodir "${instdir}/licenses"
	cp -pPR * "${D}/${instdir}"
	rm "${D}/${instdir}/unzip"
	doenvd "${FILESDIR}/90icm" || die
	if use x86; then
		dosym "${instdir}/icm"  /opt/bin/icm || die
		dosym "${instdir}/icmng" /opt/bin/icmng || die
		rm  "${D}/${instdir}/icm64" || die
		rm  "${D}/${instdir}/icmng64" || die
		rm "${D}/${instdir}/icmora64" || die
		rm "${D}/${instdir}/icmora64.bin" || die
		rm -rf "${D}/${instdir}/lib64" || die
	elif use amd64; then
		if use 32bit; then
			dosym "${instdir}/icm"  /opt/bin/icm || die
			dosym "${instdir}/icmng" /opt/bin/icmng || die
		fi
		if use 64bit; then
			dosym "${instdir}/icm64" /opt/bin/icm64 || die
			dosym "${instdir}/icmng64" /opt/bin/icmng64 || die
		fi
		if ! use 64bit; then
			rm  "${D}/${instdir}/icm64" || die
			rm  "${D}/${instdir}/icmng64" || die
			rm "${D}/${instdir}/icmora64{,.bin}" || die
			rm -rf "${D}/${instdir}/lib64" || die
		fi
		if ! use 32bit; then
			rm "${D}/${instdir}/icm" || die
			rm "${D}/${instdir}/icmng" || die
			rm "${D}/${instdir}/icmora" || die
			rm "${D}/${instdir}/icmora.bin" || die
			rm -rf "${D}/${instdir}/lib32" || die
		fi
	fi
	dosym "${instdir}/txdoc"  /opt/bin/txdoc || die
	dosym "${instdir}/lmhostid"  /opt/bin/lmhostid || die
	# install vim files
	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins  "${WORKDIR}/icm.vim"
		insinto /usr/share/vim/vimfiles/syntax
		doins  "${WORKDIR}/icm.vim"
		rm "${D}/${instdir}/icm.vim" || die
	fi
	# make desktop entry
	doicon "${FILESDIR}/${PN}.xpm"
	if use x86; then
		make_desktop_entry "icm -g" "ICM Pro" ${PN} Chemistry
	elif use amd64; then
		use 32bit && make_desktop_entry "icm -g" "ICM Pro (32bit)" ${PN} Chemistry
		use 64bit && make_desktop_entry "icm64 -g" "ICM Pro (64bit)" ${PN} Chemistry
	fi
}

pkg_postinst () {
	einfo
	einfo "Documentation can be found in ${instdir}/man/"
	einfo
	einfo "You will need to place your license in ${instdir}/licenses/"
	einfo

}

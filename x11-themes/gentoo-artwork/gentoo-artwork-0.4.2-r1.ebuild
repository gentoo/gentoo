# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gentoo-artwork/gentoo-artwork-0.4.2-r1.ebuild,v 1.9 2015/05/09 23:21:34 hwoarang Exp $

EAPI="5"

BI_VER="20060811"

DESCRIPTION="A collection of miscellaneous Gentoo Linux logos and artwork"
SRC_URI="pixmaps? (
		mirror://gentoo/gentoo-artwork-0.2.tar.bz2
		mirror://gentoo/gentoo-artwork-0.3.tar.bz2
		mirror://gentoo/gentoo-artwork-0.4.tar.bz2
		mirror://gentoo/gentoo-artwork-0.4.1.tar.bz2
		mirror://gentoo/gentoo-artwork-0.4.2.tar.bz2
		icons? ( mirror://gentoo/gentoo-bubble-icons-${BI_VER}.tar.gz )
	)
	!pixmaps? (
		icons? (
			mirror://gentoo/gentoo-artwork-0.2.tar.bz2
			mirror://gentoo/gentoo-artwork-0.3.tar.bz2
			mirror://gentoo/gentoo-artwork-0.4.tar.bz2
			mirror://gentoo/gentoo-artwork-0.4.2.tar.bz2
			mirror://gentoo/gentoo-bubble-icons-${BI_VER}.tar.gz
		)
		!icons? (
			kde? ( mirror://gentoo/gentoo-artwork-0.2.tar.bz2 )
			!kde? ( grub? ( mirror://gentoo/gentoo-artwork-0.2.tar.bz2 ) )
			lilo? ( mirror://gentoo/gentoo-artwork-0.4.tar.bz2 )
		)
	)"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Artwork"

KEYWORDS="alpha amd64 ~mips ppc ppc64 sparc x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"
IUSE="kde offensive +icons +pixmaps +grub lilo"
RESTRICT="binchecks strip"

DEPEND=""
RDEPEND="${DEPEND}"

src_unpack() {
	mkdir -p "${WORKDIR}"/${PN}-0.2
	if use pixmaps || use icons || use kde || use grub; then
		unpack ${PN}-0.2.tar.bz2
	fi
	# rename unpacked dir so that updated files get overwritten
	mv "${WORKDIR}"/${PN}-0.2 "${WORKDIR}"/${PN}-0.3
	if use pixmaps || use icons; then
		unpack gentoo-artwork-0.3.tar.bz2
	fi
	mv "${WORKDIR}"/${PN}-0.3 "${WORKDIR}"/${PN}-0.4
	if use pixmaps || use icons || use lilo; then
		unpack ${PN}-0.4.tar.bz2
	fi
	mv "${WORKDIR}"/${PN}-0.4 "${WORKDIR}"/${PN}-0.4.1
	if use pixmaps; then
		unpack ${PN}-0.4.1.tar.bz2
	fi
	mv "${WORKDIR}"/${PN}-0.4.1 "${WORKDIR}"/${PN}-0.4.2
	if use pixmaps || use icons; then
		unpack ${PN}-0.4.2.tar.bz2
	fi

	if use icons ; then
		# Gentoo Bubble Icons
		unpack gentoo-bubble-icons-${BI_VER}.tar.gz
		cd "${WORKDIR}"/${PN}-0.4.2/icons/gentoo

		cp "${FILESDIR}"/index.theme .

		mv l33t/l33t_BRO_lynx.png l33t/l33t_BRO_lynx2.png
		mv "${WORKDIR}"/gentoo-bubble-icons/README bubble-icons-README
		find "${WORKDIR}"/gentoo-bubble-icons -name '*.png' \
			-exec mv "{}" l33t/ \;

		# fix errors in filenames
		mv l33t/l33t_nero.png l33t/l33t_UTI_nero.png
		# fix permissions (bug #213385)
		fperms 644 l33t/l33t_MAI_mutt.png

		# remove misspelled files
		rm "${S}"/icons/gentoo/{32x32,48x48,64x64}/slypheed.png
	fi

	if use pixmaps ; then
		# bug #132271
		rm "${S}"/pixmaps/1024x768/gentoo-blue-leaf-1024x768.jpg
		rm "${S}"/pixmaps/1024x768/gentoo-blue-ute-1024x768.jpg

		# move images with wrong size to misc
		mv "${S}"/pixmaps/800x600/OpenSource_in_the_sun-1280x960.png \
			"${S}"/pixmaps/misc/OpenSource_in_the_sun-1280x960.png
		mv "${S}"/pixmaps/1024x768/Gentoo_2parts_1024x768.png \
			"${S}"/pixmaps/misc/Gentoo_2parts_1024x786.png
		mv "${S}"/pixmaps/1024x768/Gentoo_transparant_1024x768.png \
			"${S}"/pixmaps/misc/Gentoo_transparant_960x768.png
		mv "${S}"/pixmaps/1280x1024/gentoo-freedom-1280x1024,jpg \
			"${S}"/pixmaps/misc/gentoo-freedom-1280x1012.jpg
		mv "${S}"/pixmaps/1280x1024/gentoowired.jpg \
			"${S}"/pixmaps/misc/gentoowired-1280x960.jpg
		mv "${S}"/pixmaps/1600x1200/gentoo-slip-1600x1200.jpg \
			"${S}"/pixmaps/misc/gentoo-slip-1200x1024.jpg
	fi

	if ! use offensive ; then
		for i in $(<"${FILESDIR}"/offensive_list) ; do
			rm -f "${S}/${i}"
		done
	fi
}

src_install() {
	if use pixmaps ; then
		# pixmaps
		dodir /usr/share/pixmaps/gentoo/
		cd "${S}"/pixmaps
		cp -pPR . "${D}"/usr/share/pixmaps/gentoo/
		rm "${D}"/usr/share/pixmaps/gentoo/CREDITS
		dodoc "${S}"/pixmaps/CREDITS
	fi

	if use kde ; then
		# a Gentoo colour scheme for KDE
		insinto /usr/share/apps/kdisplay/color-schemes
		doins "${S}"/misc/Gentoo.kcsrc
	fi

	if use icons ; then
		# Gentoo icons
		dodir /usr/share/icons/gentoo
		cp -pR "${S}"/icons/gentoo/* "${D}"/usr/share/icons/gentoo/
	fi

	if use grub ; then
		# grub splash images
		dodir /usr/share/grub/splashimages
		insinto /usr/share/grub/splashimages
		doins "${S}"/grub/*.xpm.gz
	fi

	if use lilo ; then
		# lilo splash images
		dodir /usr/share/lilo/splashimages
		insinto /usr/share/lilo/splashimages
		doins "${S}"/lilo/*
		rm "${D}"/usr/share/lilo/splashimages/lilo.txt
		dodoc "${S}"/lilo/lilo.txt
	fi
}

pkg_postinst() {
	einfo "E-mail any artwork for this package at artwork@gentoo.org"
}

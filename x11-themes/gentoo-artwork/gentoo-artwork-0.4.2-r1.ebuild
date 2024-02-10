# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BI_VER="20060811"

DESCRIPTION="Collection of miscellaneous Gentoo Linux logos and artwork"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Artwork"
SRC_URI="
	pixmaps? (
		mirror://gentoo/gentoo-artwork-0.2.tar.bz2
		mirror://gentoo/gentoo-artwork-0.3.tar.bz2
		mirror://gentoo/gentoo-artwork-0.4.tar.bz2
		mirror://gentoo/gentoo-artwork-0.4.1.tar.bz2
		mirror://gentoo/gentoo-artwork-${PV}.tar.bz2
		icons? ( mirror://gentoo/gentoo-bubble-icons-${BI_VER}.tar.gz )
	)
	!pixmaps? (
		icons? (
			mirror://gentoo/gentoo-artwork-0.2.tar.bz2
			mirror://gentoo/gentoo-artwork-0.3.tar.bz2
			mirror://gentoo/gentoo-artwork-0.4.tar.bz2
			mirror://gentoo/gentoo-artwork-${PV}.tar.bz2
			mirror://gentoo/gentoo-bubble-icons-${BI_VER}.tar.gz
		)
		!icons? (
			kde? ( mirror://gentoo/gentoo-artwork-0.2.tar.bz2 )
			!kde? ( grub? ( mirror://gentoo/gentoo-artwork-0.2.tar.bz2 ) )
			lilo? ( mirror://gentoo/gentoo-artwork-0.4.tar.bz2 )
		)
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~mips ppc ppc64 sparc x86"
IUSE="+grub +icons kde lilo offensive +pixmaps"
RESTRICT="binchecks strip"

src_unpack() {
	mkdir -p "${WORKDIR}"/${PN}-0.2 || die
	if use pixmaps || use icons || use kde || use grub; then
		unpack ${PN}-0.2.tar.bz2
	fi
	# rename unpacked dir so that updated files get overwritten
	mv "${WORKDIR}"/${PN}-0.2 "${WORKDIR}"/${PN}-0.3 || die
	if use pixmaps || use icons; then
		unpack gentoo-artwork-0.3.tar.bz2
	fi
	mv "${WORKDIR}"/${PN}-0.3 "${WORKDIR}"/${PN}-0.4 || die
	if use pixmaps || use icons || use lilo; then
		unpack ${PN}-0.4.tar.bz2
	fi
	mv "${WORKDIR}"/${PN}-0.4 "${WORKDIR}"/${PN}-0.4.1 || die
	if use pixmaps; then
		unpack ${PN}-0.4.1.tar.bz2
	fi
	mv "${WORKDIR}"/${PN}-0.4.1 "${WORKDIR}"/${PN}-0.4.2 || die
	if use pixmaps || use icons; then
		unpack ${PN}-0.4.2.tar.bz2
	fi

	if use icons ; then
		# Gentoo Bubble Icons
		unpack gentoo-bubble-icons-${BI_VER}.tar.gz
		pushd "${WORKDIR}"/${PN}-0.4.2/icons/gentoo >/dev/null || die

		cp "${FILESDIR}"/index.theme . || die

		mv l33t/l33t_BRO_lynx.png l33t/l33t_BRO_lynx2.png || die
		mv "${WORKDIR}"/gentoo-bubble-icons/README bubble-icons-README || die
		find "${WORKDIR}"/gentoo-bubble-icons -name '*.png' \
			-exec mv "{}" l33t/ \; || die

		# fix errors in filenames
		mv l33t/l33t_nero.png l33t/l33t_UTI_nero.png || die
		# fix permissions (bug #213385)
		chmod -x l33t/l33t_MAI_mutt.png || die

		# remove misspelled files
		rm "${S}"/icons/gentoo/{32x32,48x48,64x64}/slypheed.png || die

		popd >/dev/null || die
	fi

	if use pixmaps ; then
		# bug #132271
		rm "${S}"/pixmaps/1024x768/gentoo-blue-leaf-1024x768.jpg || die
		rm "${S}"/pixmaps/1024x768/gentoo-blue-ute-1024x768.jpg || die

		# move images with wrong size to misc
		mv "${S}"/pixmaps/800x600/OpenSource_in_the_sun-1280x960.png \
			"${S}"/pixmaps/misc/OpenSource_in_the_sun-1280x960.png || die
		mv "${S}"/pixmaps/1024x768/Gentoo_2parts_1024x768.png \
			"${S}"/pixmaps/misc/Gentoo_2parts_1024x786.png || die
		mv "${S}"/pixmaps/1024x768/Gentoo_transparant_1024x768.png \
			"${S}"/pixmaps/misc/Gentoo_transparant_960x768.png || die
		mv "${S}"/pixmaps/1280x1024/gentoo-freedom-1280x1024,jpg \
			"${S}"/pixmaps/misc/gentoo-freedom-1280x1012.jpg || die
		mv "${S}"/pixmaps/1280x1024/gentoowired.jpg \
			"${S}"/pixmaps/misc/gentoowired-1280x960.jpg || die
		mv "${S}"/pixmaps/1600x1200/gentoo-slip-1600x1200.jpg \
			"${S}"/pixmaps/misc/gentoo-slip-1200x1024.jpg || die
	fi

	if ! use offensive ; then
		local i
		for i in $(<"${FILESDIR}"/offensive_list) ; do
			rm -f "${S}/${i}" || die
		done
	fi
}

src_install() {
	if use pixmaps ; then
		# pixmaps
		dodir /usr/share/pixmaps/gentoo/
		cd "${S}"/pixmaps || die
		cp -pPR . "${D}"/usr/share/pixmaps/gentoo/ || die
		rm "${D}"/usr/share/pixmaps/gentoo/CREDITS || die
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
		cp -pR "${S}"/icons/gentoo/* "${D}"/usr/share/icons/gentoo/ || die
	fi

	if use grub ; then
		# grub splash images
		insinto /usr/share/grub/splashimages
		doins "${S}"/grub/*.xpm.gz
	fi

	if use lilo ; then
		# lilo splash images
		insinto /usr/share/lilo/splashimages
		doins "${S}"/lilo/*
		rm "${D}"/usr/share/lilo/splashimages/lilo.txt || die
		dodoc "${S}"/lilo/lilo.txt
	fi
}

pkg_postinst() {
	einfo "E-mail any artwork for this package at artwork@gentoo.org"
}

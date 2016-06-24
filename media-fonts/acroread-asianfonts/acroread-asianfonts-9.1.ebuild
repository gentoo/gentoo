# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit confutils

SRC_PREFIX="http://ardownload.adobe.com/pub/adobe/reader/unix/9.x/9.1/misc/FontPack910_"
#SRC_SUFFIX="_i386-solaris.tar.bz2"
SRC_SUFFIX="_i486-linux.tar.bz2"

DESCRIPTION="Asian and Extended Language Font Packs used by Adobe Reader"
HOMEPAGE="http://www.adobe.com/products/acrobat/acrrasianfontpack.html"
SRC_URI="!minimal? ( ${SRC_PREFIX}xtd${SRC_SUFFIX} )
	l10n_ja? ( ${SRC_PREFIX}jpn${SRC_SUFFIX} )
	l10n_ko? ( ${SRC_PREFIX}kor${SRC_SUFFIX} )
	l10n_zh-CN? ( ${SRC_PREFIX}chs${SRC_SUFFIX} )
	l10n_zh-TW? ( ${SRC_PREFIX}cht${SRC_SUFFIX} )"

SLOT="0"
LICENSE="Adobe"
KEYWORDS="amd64 x86"
IUSE="minimal l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW"
RESTRICT="strip mirror"

DEPEND=""
RDEPEND="!<app-text/acroread-9.4.0"

S="${WORKDIR}"

REQUIRED_USE="|| ( !minimal l10n_ja l10n_ko l10n_zh-CN l10n_zh-TW )"

src_install() {
	local INSTALLDIR="/opt"
	local READERDIR="${INSTALLDIR}/Adobe/Reader9"
	local RESOURCEDIR="${READERDIR}/Resource"
	local CMAPDIR="${RESOURCEDIR}/CMap"

	dodir "${INSTALLDIR}"
	insinto "${RESOURCEDIR}"

	if use l10n_ja ; then
		tar xf JPNKIT/LANGCOM.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		tar xf JPNKIT/LANGJPN.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		doins JPNKIT/LICREAD.TXT
	fi
	if use l10n_ko ; then
		tar xf KORKIT/LANGCOM.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		tar xf KORKIT/LANGKOR.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		doins KORKIT/LICREAD.TXT
	fi
	if use l10n_zh-CN ; then
		tar xf CHSKIT/LANGCOM.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		tar xf CHSKIT/LANGCHS.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		doins CHSKIT/LICREAD.TXT
	fi
	if use l10n_zh-TW ; then
		tar xf CHTKIT/LANGCOM.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		tar xf CHTKIT/LANGCHT.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		doins CHTKIT/LICREAD.TXT
	fi

	if use !minimal ; then
		tar xf xtdfont/XTDFONT.TAR --no-same-owner -C "${D}/${INSTALLDIR}"
		rm "${D}${RESOURCEDIR}"/Font/{MinionPro*,MyriadPro*}

		doins "${D}${INSTALLDIR}"/LICREAD.TXT
		rm "${D}${INSTALLDIR}"/{INSTALL,LICREAD.TXT}
		rm -rf "${D}${READERDIR}"/Reader/intellinux
	fi

	# collision with app-text/acroread, bug #152288
	if use l10n_ja || use l10n_ko || use l10n_zh-CN || use l10n_zh-TW; then

		rm "${D}/${CMAPDIR}"/Identity-{V,H}

		if use !l10n_ja ; then
			rm "${D}/${CMAPDIR}"/{8*,9*,Add*,Adobe-J*,EUC*,Ext*,H,UCS2-9*,UniJ*,UniKS-UTF16*,V}
		fi
		#if use !l10n_ko ; then
		#	rm "${D}/${CMAPDIR}"/{Adobe-Korea*,KSC*,UCS2-GBK*,UCS2-KSC*,UniKS*}
		#fi
		#if use !l10n_zh-CN ; then
		#	rm "${D}/${CMAPDIR}"/{Adobe-GB*,GB*,UCS2-GB*,UniGB*}
		#fi
		#if use !l10n_zh-TW ; then
		#	rm "${D}/${CMAPDIR}"/{Adobe-CNS*,B5*,CNS*,ET*,HK*,UCS2-B5*,UCS-ET*,UniCNS*}
		#fi
	fi

	fowners -R -L --dereference 0:0 "${INSTALLDIR}"
}

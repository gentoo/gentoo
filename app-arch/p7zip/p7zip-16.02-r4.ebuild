# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WX_GTK_VER="3.0"

inherit eutils toolchain-funcs wxwidgets

DESCRIPTION="Port of 7-Zip archiver for Unix"
HOMEPAGE="http://p7zip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}_src_all.tar.bz2"

LICENSE="LGPL-2.1 rar? ( unRAR )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="abi_x86_x32 doc kde +pch rar static wxwidgets"

REQUIRED_USE="kde? ( wxwidgets )"

RDEPEND="wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	abi_x86_x32? ( >=dev-lang/yasm-1.2.0-r1 )
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/nasm )"

S=${WORKDIR}/${PN}_${PV}

DOCS=( ChangeLog README TODO )

PATCHES=(
	"${FILESDIR}"/${P}-darwin.patch
	"${FILESDIR}"/CVE-2016-9296.patch
	"${FILESDIR}"/CVE-2017-17969.patch
	"${FILESDIR}"/CVE-2018-5996.patch
	"${FILESDIR}"/CVE-2018-10115.patch
)

src_prepare() {
	default

	if ! use pch; then
		sed "s:PRE_COMPILED_HEADER=StdAfx.h.gch:PRE_COMPILED_HEADER=:g" -i makefile.* || die
	fi

	sed \
		-e 's|-m32 ||g' \
		-e 's|-m64 ||g' \
		-e 's|-pipe||g' \
		-e '/ALLFLAGS/s|-s ||' \
		-e "/OPTFLAGS=/s|=.*|=${CXXFLAGS}|" \
		-i makefile* || die

	# remove non-free RAR codec
	if use rar; then
		ewarn "Enabling nonfree RAR decompressor"
	else
		sed \
			-e '/Rar/d' \
			-e '/RAR/d' \
			-i makefile* CPP/7zip/Bundles/Format7zFree/makefile || die
		rm -rf CPP/7zip/Compress/Rar || die
	fi

	if use abi_x86_x32; then
		sed -i -e "/^ASM=/s:amd64:x32:" makefile* || die
		cp -f makefile.linux_amd64_asm makefile.machine || die
	elif use amd64; then
		cp -f makefile.linux_amd64_asm makefile.machine || die
	elif use x86; then
		cp -f makefile.linux_x86_asm_gcc_4.X makefile.machine || die
	elif [[ ${CHOST} == *-darwin* ]] ; then
		# Mac OS X needs this special makefile, because it has a non-GNU
		# linker, it doesn't matter so much for bitwidth, for it doesn't
		# do anything with it
		cp -f makefile.macosx_llvm_64bits makefile.machine
		# bundles have extension .bundle but don't die because USE=-rar
		# removes the Rar directory
		sed -i -e '/strcpy(name/s/\.so/.bundle/' \
			CPP/Windows/DLL.cpp || die
		sed -i -e '/^PROG=/s/\.so/.bundle/' \
			CPP/7zip/Bundles/Format7zFree/makefile.list \
			$(use rar && echo CPP/7zip/Compress/Rar/makefile.list) || die
	elif use x86-fbsd; then
		# FreeBSD needs this special makefile, because it hasn't -ldl
		sed -e 's/-lc_r/-pthread/' makefile.freebsd > makefile.machine
	fi

	if use static; then
		sed -i -e '/^LOCAL_LIBS=/s/LOCAL_LIBS=/&-static /' makefile.machine || die
	fi

	if use kde || use wxwidgets; then
		need-wxwidgets unicode
		einfo "Preparing dependency list"
		emake depend
	fi
}

src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) all3
	if use kde || use wxwidgets; then
		emake CC=$(tc-getCC) CXX=$(tc-getCXX) -- 7zG
#		emake -- 7zFM
	fi
}

src_test() {
	emake test test_7z test_7zr
}

src_install() {
	# this wrappers can not be symlinks, p7zip should be called with full path
	make_wrapper 7zr "/usr/$(get_libdir)/${PN}/7zr"
	make_wrapper 7za "/usr/$(get_libdir)/${PN}/7za"
	make_wrapper 7z "/usr/$(get_libdir)/${PN}/7z"

	if use kde || use wxwidgets; then
		make_wrapper 7zG "/usr/$(get_libdir)/${PN}/7zG"
#		make_wrapper 7zFM "/usr/$(get_libdir)/${PN}/7zFM"

#		make_desktop_entry 7zFM "${PN} FM" ${PN} "GTK;Utility;Archiving;Compression"

		dobin GUI/p7zipForFilemanager
		exeinto /usr/$(get_libdir)/${PN}
#		doexe bin/7z{G,FM}
		doexe bin/7zG

		insinto /usr/$(get_libdir)/${PN}
		doins -r GUI/Lang
		doins -r DOC/MANUAL

		insinto /usr/share/icons/hicolor/16x16/apps/
		newins GUI/p7zip_16_ok.png p7zip.png

		if use kde; then
			rm GUI/kde4/p7zip_compress.desktop || die
			insinto /usr/share/kservices5/ServiceMenus
			doins GUI/kde4/*.desktop
			dodir /usr/share/kde4/services/ServiceMenus # drop these lines after konqueror:4/krusader:4 are gone
			for item in "${ED}"usr/share/kservices5/ServiceMenus/*.desktop; do
				item="$(basename ${item})"
				dosym "/usr/share/kservices5/ServiceMenus/${item}" "/usr/share/kde4/services/ServiceMenus/${item}"
			done
		fi
	fi

	dobin contrib/gzip-like_CLI_wrapper_for_7z/p7zip
	doman contrib/gzip-like_CLI_wrapper_for_7z/man1/p7zip.1

	exeinto /usr/$(get_libdir)/${PN}
	doexe bin/7z bin/7za bin/7zr bin/7zCon.sfx
	doexe bin/*$(get_modname)
	if use rar; then
		exeinto /usr/$(get_libdir)/${PN}/Codecs/
		doexe bin/Codecs/*$(get_modname)
	fi

	doman man1/7z.1 man1/7za.1 man1/7zr.1

	if use doc; then
		dodoc DOC/*.txt
		dohtml -r DOC/MANUAL/*
	fi
}

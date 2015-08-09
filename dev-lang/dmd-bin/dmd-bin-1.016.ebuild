# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P=${P/-bin/}
MY_P=${MY_P/-/.}

DESCRIPTION="Digital Mars D Compiler"
HOMEPAGE="http://www.digitalmars.com/d/"
SRC_URI="http://ftp.digitalmars.com/${MY_P}.zip"

LICENSE="DMD"
SLOT="0"
KEYWORDS="~x86"
RESTRICT="mirror strip"

LOC="/opt/dmd"
S="${WORKDIR}"

DEPEND="sys-apps/findutils
	app-arch/unzip"
RDEPEND="~virtual/libstdc++-3.3"

src_unpack() {
	unpack ${A}

	# Remove unneccessary files
	mv "${S}"/dmd/lib/libphobos.a "${S}"/dmd
	rm -r "${S}"/dmd/lib
	mkdir "${S}"/dmd/lib
	mv "${S}"/dmd/libphobos.a "${S}"/dmd/lib

	rm -r "${S}"/dm
	rm "${S}"/dmd/bin/*.dll "${S}"/dmd/bin/*.exe "${S}"/dmd/bin/readme.txt
	rm "${S}"/dmd/bin/sc.ini "${S}"/dmd/bin/windbg.hlp

	# Cleanup line endings
	cd "${S}"/dmd
	edos2unix `find . -name '*.c' -type f`
	edos2unix `find . -name '*.d' -type f`
	edos2unix `find . -name '*.ddoc' -type f`
	edos2unix `find . -name '*.h' -type f`
	edos2unix `find . -name '*.mak' -type f`
	edos2unix `find . -name '*.txt' -type f`
	edos2unix `find samples -name '*.html' -type f`

	# Fix permissions
	fperms guo=r `find . -type f`
	fperms guo=rx `find . -type d`
	fperms guo=rx bin/dmd bin/dumpobj bin/obj2asm bin/rdmd
}

src_compile() {
	cd "${S}"/dmd/src/phobos
	sed -i -e "s:DMD=.*:DMD=${S}/dmd/bin/dmd -I${S}/dmd/src/phobos -L${S}/dmd/lib/libphobos.a:" linux.mak internal/gc/linux.mak
	edos2unix linux.mak internal/gc/linux.mak
	make -f linux.mak
	cp libphobos.a "${S}"/dmd/lib

	# Clean up
	make -f linux.mak clean
	rm internal/gc/*.o
}

src_install() {
	cd "${S}"/dmd

	# Broken dmd.conf
	# http://d.puremagic.com/issues/show_bug.cgi?id=278
	mv bin/dmd bin/dmd.bin
	cat <<END > "bin/dmd"
#!/bin/sh
${LOC}/bin/dmd.bin -I${LOC}/src/phobos -L${LOC}/lib/libphobos.a \$*
END
	fperms guo=rx bin/dmd bin/dmd.bin

	# Man pages
	doman man/man1/dmd.1
	doman man/man1/dumpobj.1
	doman man/man1/obj2asm.1
	rm -r man

	# Install
	mkdir "${D}/opt"
	mv "${S}/dmd" "${D}/opt/dmd"

	# Set PATH
	doenvd "${FILESDIR}/25dmd"
}

pkg_postinst () {
	ewarn "The DMD Configuration file has been disabled,    "
	ewarn "and will be re-enabled when:                     "
	ewarn "                                                 "
	ewarn "http://d.puremagic.com/issues/show_bug.cgi?id=278"
	ewarn "                                                 "
	ewarn "has been fixed. Meanwhile, please supply all your"
	ewarn "configuration options in the /opt/dmd/bin/dmd    "
	ewarn "shell script.                                    "
	ewarn "                                                 "
	ewarn "You may need to run:                             "
	ewarn "                                                 "
	ewarn "env-update && source /etc/profile                "
	ewarn "                                                 "
	ewarn "to be able to use the compiler immediately.      "
	ewarn "                                                 "
}

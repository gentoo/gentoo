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
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror strip"

LOC="/opt/dmd"
S="${WORKDIR}"

DEPEND="sys-apps/findutils
	app-arch/unzip"
RDEPEND=""

src_unpack() {
	unpack ${A}

	# Cleanup line endings
	cd "${S}/dmd"
	edos2unix `find . -name '*.c' -type f`
	edos2unix `find . -name '*.d' -type f`
	edos2unix `find . -name '*.ddoc' -type f`
	edos2unix `find . -name '*.h' -type f`
	edos2unix `find . -name '*.mak' -type f`
	edos2unix `find . -name '*.txt' -type f`
	edos2unix `find samples -name '*.html' -type f`
	edos2unix src/phobos/linux.mak src/phobos/internal/gc/linux.mak

	# Fix permissions and clean up
	fperms guo=r `find . -type f`
	fperms guo=rx `find . -type d`
	fperms guo=rx bin/dmd bin/dumpobj bin/obj2asm bin/rdmd
}

src_compile() {
	# Don't use teh bundled library since on gentoo we do teh compile
	cd "${S}/dmd/src/phobos"
	sed -i -e "s:DMD=.*:DMD=${S}/dmd/bin/dmd:" linux.mak internal/gc/linux.mak
	# Can't use emake, customized build system
	make -f linux.mak
	cp obj/release/libphobos2.a "${S}/dmd/lib"

	# Clean up
	make -f linux.mak clean
}

src_install() {
	cd "${S}/dmd"

	# Setup dmd.conf
	cat <<END > "bin/dmd.conf"
[Environment]
DFLAGS=-I/opt/dmd/src/phobos -L-L/opt/dmd/lib
END
	insinto /etc
	doins bin/dmd.conf

	# Man pages
	doman man/man1/dmd.1
	doman man/man1/dumpobj.1
	doman man/man1/obj2asm.1

	# Documentation
	dohtml "html/d/*" "html/d/phobos/*"

	# Install
	exeinto /opt/dmd/bin
	doexe bin/dmd
	doexe bin/dumpobj
	doexe bin/obj2asm
	doexe bin/rdmd

	insinto /opt/dmd/lib
	doins lib/libphobos2.a

	insinto /opt/dmd/samples
	doins "samples/d/*"

	# Phobos and DMD source
	mv src "${D}/opt/dmd/"

	# Set PATH
	doenvd "${FILESDIR}/25dmd"
}

pkg_postinst () {
	ewarn "You may need to run:                             "
	ewarn "env-update && source /etc/profile                "
	ewarn "to be able to use the compiler immediately.      "
	einfo "                                                 "
	einfo "The bundled samples and sources may be found in  "
	einfo "/opt/dmd/samples and /opt/dmd/src respectively.  "
	einfo "                                                 "
}

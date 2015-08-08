# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnat versionator

IUSE=""

Name="XmlAda"

DESCRIPTION="XML library for Ada"
HOMEPAGE="http://libre2.adacore.com/xmlada/"
SRC_URI="https://libre2.adacore.com/xmlada/${Name}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="virtual/gnat
	>=sys-apps/sed-4"
RDEPEND=""

src_unpack()
{
	unpack ${A}

	cd "${S}"
	#making .dvi docs is problemmatic. Skip that for now
	sed -i -e "s/all: obj test docs/all: obj test/" Makefile.in
	#increase stack size
	cd sax
	sed -i -e "s/Stack_Size : constant Natural := 64;/Stack_Size : constant Natural := 128;/" sax-readers.adb
}

lib_compile()
{
	# for some reason shared libs are assigned version numbers from some
	# pre-release (possibly when upstream stopped to care about them?)
	local MAJOR=$(get_major_version)
	local MINOR=$(get_version_component_range 2-)
	# force building shared libs and fix broken shared lib versioning
	sed -i -e "s:BUILD_SHARED=FALSE:BUILD_SHARED=TRUE:" \
		-e "s:libxmlada_\${@\:%_install=%}-\${MAJOR}.\${MINOR}.so:libxmlada_\${@\:%_inst=%}.so.${MAJOR}.${MINOR}:" \
		-e "s:libxmlada_\${@\:%_inst=%}-\${MAJOR}.\${MINOR}.so:libxmlada_\${@\:%_inst=%}.so.${MAJOR}.${MINOR}:" \
		-e "s:FPIC=:FPIC=-fPIC:" Makefile.in

	export CFLAGS=$ADACFLAGS
	./configure --prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--enable-shared \
		--host=${CHOST} \
		--build=${CHOST} \
		--target=${CHOST} \
		--with-system-zlib || die

	export COMPILER=gnatmake
	make || die "make failed"
}

# here we need to use the $1 - passed gnat profile name
lib_install() {
	make PREFIX="${DL}" install || die "install failed"

	# fix xmlada-config hardsets locations
	sed -i -e "s:\${prefix}/include/xmlada:${AdalibSpecsDir}/${PN}:" \
		-e "s:\${prefix}/lib:${AdalibLibTop}/$1/${PN}:g" \
		"${DL}"/bin/xmlada-config

	# now move stuff to proper location and delete extras
	mv "${DL}"/bin/xmlada-config "${DL}"/lib/* "${DL}"/include/${PN}/*.ali "${DL}"
	rm -rf "${DL}"/bin "${DL}"/include "${DL}"/lib
}

src_install ()
{
	cd "${S}"
	dodir ${AdalibSpecsDir}/${PN}
	insinto ${AdalibSpecsDir}/${PN}
	doins dom/*.ad? input_sources/*.ad? sax/*.ad? unicode/*.ad?

	#set up environment
	echo "PATH=%DL%" > ${LibEnv}
	echo "LDPATH=%DL%" >> ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=/usr/include/ada/${PN}" >> ${LibEnv}

	gnat_src_install

	dodoc AUTHORS README docs/xml.ps
	dohtml docs/*.html
	doinfo docs/*.info
	#need to give a proper name to the info file
	cd "${D}"/usr/share/info
	mv xml.info.gz ${PN}.info.gz

}

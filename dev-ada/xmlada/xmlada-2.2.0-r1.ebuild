# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gnat versionator

IUSE=""

DESCRIPTION="XML library for Ada"
HOMEPAGE="http://libre.adacore.com/xmlada/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

DEPEND="virtual/ada
	virtual/latex-base
	sys-apps/texinfo
	>=sys-apps/sed-4"
RDEPEND=""

src_unpack()
{
	unpack ${A}
	cd "${S}"

	# adjusting profile independent stuff in project files
#	for fn in distrib/*/xmlada*.gpr; do
#		sed -i -e "s:../../include/xmlada:${AdalibSpecsDir}/${PN}:" ${fn}
#	done
	sed -i -e "s:\.\./\.\./include/xmlada:${AdalibSpecsDir}/${PN}:" \
		distrib/*/xmlada*.gpr || die "failed to adjust project files"

	# fix profile independent stuff in xmlada-config
	sed -i -e "s:\${prefix}/include/xmlada:${AdalibSpecsDir}/${PN}:" \
		xmlada-config.in || die "failed to adjust xmlada-config"

	# doinfo changed from gzipping stuff to bzipping, so we better rename the
	# file before calling it to guard against other possible changes
	mv docs/xml.info docs/${PN}.info
}

lib_compile()
{
	econf
	emake
}

# NOTE: we are using $1 - the passed gnat profile name
lib_install() {
	# bug #283160
	emake -j1 PREFIX="${DL}" install || die "install failed"

	pushd "${DL}"
		# fix xmlada-config hardsets locations and move it to proper location
		sed -i -e "s:\${prefix}/lib/xmlada:${AdalibLibTop}/$1/${PN}:" \
			-e "s:\${prefix}/lib:${AdalibLibTop}/$1/${PN}:g" \
			bin/xmlada-config
		mv bin/xmlada-config "${DLbin}"

		# sed and organize gpr files
		sed -i -e "s:\.\./xmlada:${AdalibLibTop}/$1/${PN}:" "${DL}"/lib/gnat/*.gpr
		mv lib/gnat/* "${DLgpr}"

		# the library and *.ali
		mv lib/${PN}/* .
		rm -rf bin include share lib

		# fix the .so links
		rm *.so
		for fn in *.so.* ; do
			ln -s ${fn} ${fn%so*}so
		done
	popd
}

src_install ()
{
	cd "${S}"
	dodir ${AdalibSpecsDir}/${PN}
	insinto ${AdalibSpecsDir}/${PN}
	doins dom/*.ad? input_sources/*.ad? sax/*.ad? unicode/*.ad? schema/*.ad?

	#set up environment
	echo "PATH=%DLbin%" > ${LibEnv}
	echo "LDPATH=%DL%" >> ${LibEnv}
	echo "ADA_OBJECTS_PATH=%DL%" >> ${LibEnv}
	echo "ADA_INCLUDE_PATH=${AdalibSpecsDir}/${PN}" >> ${LibEnv}
	echo "ADA_PROJECT_PATH=%DLgpr%" >> ${LibEnv}

	gnat_src_install

	dodoc AUTHORS README TODO features
	dohtml docs/*.html
	doinfo docs/*.info
	insinto /usr/share/doc/${PF}
	doins docs/*.pdf distrib/xmlada_gps.py

	dodir /usr/share/doc/${PF}/examples
	insinto /usr/share/doc/${PF}/examples
	doins -r docs/{dom,sax,schema}
}

# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

JAVA_SUPPORTS_GENERATION_1="true"
inherit java-vm-2 multilib

DESCRIPTION="Landon Fuller's Java 6 for Mac OS X 10.4 and 10.5"
HOMEPAGE="http://landonf.bikemonkey.org/static/soylatte/"
DLURL="http://landonf.bikemonkey.org/static/soylatte/bsd-dist/javasrc_1_6_jrl_darwin"
SRC_URI="
	x86-macos? ( ${DLURL}/soylatte16-i386-${PV}.tar.bz2 )
	x64-macos? ( ${DLURL}/soylatte16-amd64-${PV}.tar.bz2 )
"
SLOT="1.6"
LICENSE="sun-jrl"
KEYWORDS="~x86-macos ~x64-macos"
IUSE="examples"

RDEPEND="dev-db/unixODBC"

JAVA_PROVIDE="jdbc-stdext"

MY_P=soylatte16-i386-${PV}
use x64-macos && MY_P=soylatte16-amd64-${PV}

S=${WORKDIR}/${MY_P}

src_prepare() {
	# fix install_names
	local arch=i586
	use x64-macos && arch=amd64
	local original_root=/data/Users/landonf/Documents/Code/Java/javasrc_1_6_jrl_darwin_stable/control/build/bsd-${arch}
	local original_demo=${original_root}/demo
	local original_lib=${original_root}/lib
	for dir in demo jre ; do
		for dynamic_lib in $(find ${dir} -name '*.dylib'); do
			install_name_tool \
				-id "${EPREFIX}"/opt/${P}/${dynamic_lib} \
				${dynamic_lib}
			for linked_against in $(scanmacho -BF'%n#f' ${dynamic_lib} | tr ',' ' '); do
				case ${linked_against} in
					${original_lib}/*)
						install_name_tool -change \
							${linked_against} \
							"${EPREFIX}"/opt/${P}/jre${linked_against#${original_root}} \
							${dynamic_lib}
					;;
					${original_demo}/*)
						install_name_tool -change \
							${linked_against} \
							"${EPREFIX}"/opt/${P}${linked_against#${original_root}} \
							${dynamic_lib}
					;;
					libjvm.dylib)
						# 64-bits binary has no client, so default to server JVM
						install_name_tool -change \
							${linked_against} \
							"${EPREFIX}"/opt/${P}/jre/lib/$(use x86-macos && echo i386/client || echo amd64/server)/libjvm.dylib \
							${dynamic_lib}
					;;
					*/libodbc*.dylib)
						install_name_tool -change \
							${linked_against} \
							"${EPREFIX}"/usr/$(get_libdir)/${linked_against##*/} \
							${dynamic_lib}
					;;
				esac
			done
		done
	done
}

src_install() {
	local dirs="bin include jre lib man"
	dodir /opt/${P}

	cp -pPR $dirs "${ED}/opt/${P}/" || die "failed to copy"
	dodoc COPYRIGHT || die
	dohtml README.html || die

	cp -pP src.zip "${ED}/opt/${P}/" || die

	if use examples; then
		cp -pPR demo sample "${ED}/opt/${P}/" || die
	fi

	# create dir for system preferences
	dodir /opt/${P}/jre/.systemPrefs
	# Create files used as storage for system preferences.
	touch "${ED}"/opt/${P}/jre/.systemPrefs/.system.lock
	chmod 644 "${ED}"/opt/${P}/jre/.systemPrefs/.system.lock
	touch "${ED}"/opt/${P}/jre/.systemPrefs/.systemRootModFile
	chmod 644 "${ED}"/opt/${P}/jre/.systemPrefs/.systemRootModFile

	set_java_env
}

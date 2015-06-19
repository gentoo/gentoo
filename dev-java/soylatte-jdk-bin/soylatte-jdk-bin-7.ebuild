# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/soylatte-jdk-bin/soylatte-jdk-bin-7.ebuild,v 1.1 2012/10/30 20:23:46 grobian Exp $

EAPI="3"

JAVA_SUPPORTS_GENERATION_1="true"
inherit java-vm-2 multilib

DESCRIPTION="Landon Fuller's OpenJDK 7 for Mac OS X 10.5/PPC"
HOMEPAGE="http://landonf.bikemonkey.org/static/soylatte/"
SRC_URI="http://landonf.bikemonkey.org/static/soylatte/bsd-dist/openjdk7_darwin/openjdk7-macppc-2009-12-16-b4.tar.bz2"
SLOT="1.7"
LICENSE="GPL-2-with-exceptions"
KEYWORDS="~ppc-macos"
IUSE="examples"

RDEPEND="dev-db/unixODBC"

JAVA_PROVIDE="jdbc-stdext"

S=${WORKDIR}/openjdk7-macppc-2009-12-16-b4

src_prepare() {
	# fix install_names
	local original_root=/Users/landonf/Desktop/openjdk-ppc/bsd-port/build/bsd-ppc
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
						install_name_tool -change \
							${linked_against} \
							"${EPREFIX}"/opt/${P}/jre/lib/ppc/server/libjvm.dylib \
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

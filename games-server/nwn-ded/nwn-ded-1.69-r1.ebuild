# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

LANGUAGES="linguas_en"
DIALOG_URL_BASE=http://files.bioware.com/neverwinternights/dialog/

DESCRIPTION="Neverwinter Nights Dedicated server"
HOMEPAGE="http://nwn.bioware.com/downloads/standaloneserver.html"
SRC_URI="http://files.bioware.com/neverwinternights/updates/windows/server/NWNDedicatedServer${PV}.zip
	linguas_en? ( ${DIALOG_URL_BASE}/english/NWNEnglish${PV}dialog.zip )"

LICENSE="NWN-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="${LANGUAGES}"
RESTRICT="mirror strip"

DEPEND="app-arch/unzip"

S=${WORKDIR}

dir="/opt/${PN}"
QA_PREBUILT="${dir:1}/common/nwserver"

src_unpack() {
	mkdir common || die
	cd common || die
	unpack NWNDedicatedServer${PV}.zip
	tar -zxf linuxdedserver${PV/./}.tar.gz || die
	rm -f *dedserver*.{tar.gz,sit,zip} *.exe *.dll || die
	cd ..
	local currentlocale=""
	local a
	for a in ${A}
	do
		if [ -z "${a/*dialog*/}" ] ; then
			if [ -z "${a/*English*/}" ]; then currentlocale="en"; fi
			if [ -z "${a/*French*/}" ]; then currentlocale="fr"; fi
			if [ -z "${a/*German*/}" ]; then currentlocale="de"; fi
			if [ -z "${a/*Italian*/}" ]; then currentlocale="it"; fi
			if [ -z "${a/*Spanish*/}" ]; then currentlocale="es"; fi
			if [ -z "${a/*Japanese*/}" ]; then currentlocale="ja"; fi
			mkdir ${currentlocale} || die
			cd ${currentlocale} || die
			cp -rfl ../common/* . || die
			unpack "${a}"
			cd ..
		fi
	done
}

src_install() {
	dodir ${dir}

	local currentlocale
	for currentlocale in * ; do
		if [[ ${currentlocale} != "common" ]]
		then
			make_wrapper nwserver-${currentlocale} ./nwserver "${dir}/${currentlocale}" "${dir}/${currentlocale}"
		fi
	done

	mv * "${D}/${dir}"/ || die

	chmod -R g+w "${D}/${dir}"
}

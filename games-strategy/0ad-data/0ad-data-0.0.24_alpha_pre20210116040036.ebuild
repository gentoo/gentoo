# Copyright 2014-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="0ad"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/0ad/0ad"
	ZEROAD_GIT_REVISION=""
elif [[ ${PV} == *_pre* ]]; then
	ZEROAD_GIT_REVISION="c7d07d3979f969b969211a5e5748fa775f6768a7"
else
	MY_P="${MY_PN}-${PV/_/-}"
fi

DESCRIPTION="Data files for 0ad"
HOMEPAGE="https://play0ad.com/"
if [[ ${PV} == 9999 ]]; then
	SRC_URI=""
elif [[ ${PV} == *_pre* ]]; then
	SRC_URI="https://github.com/0ad/0ad/archive/${ZEROAD_GIT_REVISION}.tar.gz -> ${MY_PN}-${PV}.tar.gz"
else
	SRC_URI="http://releases.wildfiregames.com/${MY_P}-unix-data.tar.xz"
fi

LICENSE="BitstreamVera CC-BY-SA-3.0 GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

if [[ ${PV} == 9999 || ${PV} == *_pre* ]]; then
	BDEPEND="~games-strategy/0ad-${PV}[nvtt]"
else
	BDEPEND=""
fi
DEPEND=""
RDEPEND=""

if [[ ${PV} == 9999 ]]; then
	S="${WORKDIR}/${MY_PN}-${PV}"
elif [[ ${PV} == *_pre* ]]; then
	S="${WORKDIR}/${MY_PN}-${ZEROAD_GIT_REVISION}"
else
	S="${WORKDIR}/${MY_P}"
fi

src_prepare() {
	default
	rm binaries/data/tools/fontbuilder/fonts/*.txt || die
}

src_compile() {
	if [[ ${PV} == 9999 || ${PV} == *_pre* ]]; then
		# source/lib/sysdep/os/linux/ldbg.cpp:debug_SetThreadName() tries to open /proc/self/task/${TID}/comm for writing.
		addpredict /proc/self/task

		# Based on source/tools/dist/build-archives.sh used by source/tools/dist/build.sh.
		local archivebuild_input archivebuild_output mod_name
		for archivebuild_input in binaries/data/mods/[A-Za-z0-9]*; do
			mod_name="${archivebuild_input##*/}"
			archivebuild_output="archives/${mod_name}"

			mkdir -p "${archivebuild_output}"

			einfo 0ad -archivebuild="${archivebuild_input}" -archivebuild-output="${archivebuild_output}/${mod_name}.zip"
			0ad -archivebuild="${archivebuild_input}" -archivebuild-output="${archivebuild_output}/${mod_name}.zip" || die

			if [[ -f "${archivebuild_input}/mod.json" ]]; then
				cp "${archivebuild_input}/mod.json" "${archivebuild_output}"
			fi

			rm -r "${archivebuild_input}" || die
			mv "${archivebuild_output}" "${archivebuild_input}" || die
		done

		# Based on source/tools/dist/build-unix-win32.sh used by source/tools/dist/build.sh.
		rm binaries/data/config/dev.cfg || die
		rm -r binaries/data/mods/_test.* || die
	fi
}

src_install() {
	insinto /usr/share/0ad
	doins -r binaries/data/{config,mods,tools}
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="RAR compressor/uncompressor"
HOMEPAGE="https://rarlab.com/"
URI_x86="https://mirror.whissi.de/distfiles/rar/rarlinux-${PV}.tar.gz"
URI_amd64="https://mirror.whissi.de/distfiles/rar/rarlinux-x64-${PV}.tar.gz"
URI_w64="https://mirror.whissi.de/distfiles/rar/winrar-x64-${PV}.exe"
SRC_URI="x86? ( ${URI_x86} )
	amd64? ( ${URI_amd64} )
	all_sfx? (
		${URI_x86}
		${URI_amd64}
		${URI_w64}
	)"

LICENSE="RAR BSD BSD-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="all_sfx"
RESTRICT="mirror bindist"

DEPEND="all_sfx? ( app-arch/unrar )"
RDEPEND="sys-libs/glibc"

S="${WORKDIR}/${PN}"

QA_FLAGS_IGNORED="opt/rar/default.sfx
	opt/rar/default-elf32.sfx
	opt/rar/default-elf64.sfx
	opt/rar/default-win32.sfx
	opt/rar/default-win64.sfx
	opt/rar/WinCon.SFX
	opt/rar/WinCon64.SFX
	opt/rar/Zip.SFX
	opt/rar/Zip64.SFX
	opt/rar/unrar
	opt/rar/rar"
QA_PRESTRIPPED=${QA_FLAGS_IGNORED}

src_unpack() {
	local _file

	for _file in ${A}; do
		if [[ "${_file}" == rarli* ]]; then
			if [[ "${_file}" =~ x64 ]]; then
				if ! use amd64; then
					continue
				fi

				unpack "${_file}"
			elif [[ ! "${_file}" =~ x64 ]]; then
				if ! use x86; then
					continue
				fi

				unpack "${_file}"
			else
				die "Unknown SRC file '${_file}'!"
			fi
		fi
	done

	rm -f "${S}"/license.txt

	if use all_sfx ; then
		mkdir sfx
		cd sfx
		for _file in ${A}; do
			if [[ "${_file}" == rarli* ]]; then
				unpack "${_file}"
				if [[ "${_file}" =~ x64 ]]; then
					mv rar/default.sfx default-elf64.sfx || die
				else
					mv rar/default.sfx default-elf32.sfx || die
				fi
			elif [[ "${_file}" == winrar* ]]; then
				ln -s "${DISTDIR}"/${_file} w64.rar || die
				unpack ./w64.rar
				mv Default.SFX default-win32.sfx || die
				mv Default64.SFX default-win64.sfx || die
			else
				die "Unknown SFX file '${_file}'!"
			fi
		done
	fi
}

src_compile() { :; }

src_install() {
	exeinto /opt/rar
	doexe rar unrar

	dodir /opt/bin
	dosym ../rar/rar /opt/bin/rar
	dosym ../rar/unrar /opt/bin/unrar

	insinto /opt/rar
	if use all_sfx ; then
		doins "${WORKDIR}"/sfx/*.{sfx,SFX}
	else
		doins default.sfx
	fi
	doins rarfiles.lst
	dodoc *.txt
}

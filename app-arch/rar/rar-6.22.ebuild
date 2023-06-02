# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="${PV/./}"
URI_AMD64="https://www.rarlab.com/rar/rarlinux-x64-${MY_PV}.tar.gz"
URI_X86="https://www.rarlab.com/rar/rarlinux-x32-${MY_PV}.tar.gz"
URI_WIN64="https://www.rarlab.com/rar/winrar-x64-${MY_PV}.exe"

inherit unpacker

DESCRIPTION="RAR compressor/uncompressor"
HOMEPAGE="https://www.rarlab.com/"
SRC_URI="
	all-sfx? (
		${URI_AMD64}
		${URI_X86}
		${URI_WIN64}
	)
	amd64? ( ${URI_AMD64} )
	x86? ( ${URI_X86} )
"
S="${WORKDIR}/${PN}"

LICENSE="BSD BSD-2 RAR"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="all-sfx"
RESTRICT="bindist mirror"

RDEPEND="sys-libs/glibc"
BDEPEND="all-sfx? ( app-arch/unrar )"

DOCS=( "acknow.txt" "rar.txt" "readme.txt" "whatsnew.txt" )

QA_PREBUILT="
	opt/rar/default.sfx
	opt/rar/default-elf32.sfx
	opt/rar/default-elf64.sfx
	opt/rar/default-win32.sfx
	opt/rar/default-win64.sfx
	opt/rar/unrar
	opt/rar/rar
	opt/rar/WinCon.SFX
	opt/rar/WinCon64.SFX
	opt/rar/Zip.SFX
	opt/rar/Zip64.SFX
"

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

	if use all-sfx ; then
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
				unpack_rar ./w64.rar
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

	insinto /opt/rar
	doins rarfiles.lst

	if use all-sfx; then
		doins "${WORKDIR}"/sfx/*.{sfx,SFX}
	else
		doins default.sfx
	fi

	dodir /opt/bin
	dosym ../rar/rar /opt/bin/rar
	dosym ../rar/unrar /opt/bin/unrar

	docinto html
	dodoc order.htm

	einstalldocs
}

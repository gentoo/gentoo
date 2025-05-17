# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Classes/Types to read and edit executable files"
HOMEPAGE="https://github.com/sashs/filebytes"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/sashs/filebytes"
else
	SRC_URI="https://github.com/sashs/filebytes/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
fi

LICENSE="BSD"
SLOT="0"

python_test() {
	"${EPYTHON}" -  <<-EOF || die "Tests failed with ${EPYTHON}"
		from filebytes.elf import *
		elf_file = ELF('test-binaries/ls-x86')
		print("elf", elf_file.elfHeader, elf_file.sections, elf_file.segments)

		from filebytes.pe import *
		pe_file = PE('test-binaries/cmd-x86.exe')
		print("pe", pe_file.imageDosHeader, pe_file.sections)
	EOF
}

# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN//-bin/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Conversion between markup formats (binary package)"
HOMEPAGE="https://pandoc.org/
	https://github.com/jgm/pandoc/"

BASE_URI="https://github.com/jgm/${MY_PN}/releases/download/${PV}/${MY_P}"
SRC_URI="
	amd64? ( ${BASE_URI}-linux-amd64.tar.gz )
	arm64? ( ${BASE_URI}-linux-arm64.tar.gz )
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="-* amd64 arm64"
IUSE="+pandoc-symlink"

RDEPEND="
	pandoc-symlink? (
		!${CATEGORY}/${MY_PN}
		!app-text/pandoc-cli
		!dev-haskell/pandoc
	)
"

QA_FLAGS_IGNORED="usr/bin/${PN}"
QA_PRESTRIPPED="${QA_FLAGS_IGNORED}"

src_unpack() {
	default

	# Manpages are gzipped.
	unpack "${S}/share/man/man1"/*.1.gz
}

src_install() {
	exeinto /usr/bin
	newexe "./bin/${MY_PN}" "${PN}"

	dosym "${PN}" /usr/bin/pandoc-lua-bin
	dosym "${PN}" /usr/bin/pandoc-server-bin

	newman "${WORKDIR}/${MY_PN}.1" "${PN}.1"
	newman "${WORKDIR}/${MY_PN}-lua.1" pandoc-lua-bin.1
	newman "${WORKDIR}/${MY_PN}-server.1" pandoc-server-bin.1

	if use pandoc-symlink ; then
		local -a exes=(
			pandoc
			pandoc-lua
			pandoc-server
		)

		local exe=""
		for exe in "${exes[@]}" ; do
			dosym "${exe}-bin" "/usr/bin/${exe}"
			dosym "${exe}-bin.1" "/usr/share/man/man1/${exe}.1"
		done
	fi
}

# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fork of bash enabling integration into pkgcraft"
HOMEPAGE="https://github.com/pkgcraft/bash"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/pkgcraft/bash.git"
	inherit git-r3
else
	SRC_URI="https://github.com/pkgcraft/bash/releases/download/${P}/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		git-r3_src_unpack
	else
		default
	fi
}

src_configure() {
	# load required configure options
	local -a myconf
	while IFS= read -r line; do
		[[ -z ${line} || ${line} =~ ^# ]] && continue
		myconf+=( ${line} )
	done < configure-scallop-options

	econf "${myconf[@]}"
}

src_compile() {
	emake libscallop.so
}

# tests rely on functionality that scallop alters
src_test() { :; }

src_install() {
	emake DESTDIR="${D}" install-library install-headers
}

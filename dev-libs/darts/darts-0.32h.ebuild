# Copyright 2003-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
WANT_LIBTOOL="none"

inherit autotools

DESCRIPTION="Darts-clone (Double-ARray Trie System) C++ library"
# Original upstream: http://chasen.org/~taku/software/darts/
HOMEPAGE="https://github.com/s-yata/darts-clone https://code.google.com/archive/p/darts-clone/"
SRC_URI="https://github.com/s-yata/darts-clone/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/darts-clone-${PV}"
fi

src_prepare() {
	default
	eaclocal
	eautoconf
	eautomake
}

src_install() {
	default

	local language source_file target_file
	for source_file in doc/*/*.md; do
		language="${source_file#*/}"
		language="${language%%/*}"
		target_file="${source_file##*/}"
		target_file="${target_file%.md}.${language}.md"
		newdoc "${source_file}" "${target_file}"
	done
}

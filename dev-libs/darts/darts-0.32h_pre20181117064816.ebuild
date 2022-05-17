# Copyright 2003-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
WANT_LIBTOOL="none"

inherit autotools

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/s-yata/darts-clone"
else
	DARTS_CLONE_GIT_REVISION="e40ce4627526985a7767444b6ed6893ab6ff8983"
fi

DESCRIPTION="Darts-clone (Double-ARray Trie System) C++ library"
# Original upstream: http://chasen.org/~taku/software/darts/
HOMEPAGE="https://github.com/s-yata/darts-clone https://code.google.com/archive/p/darts-clone/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/s-yata/darts-clone/archive/${DARTS_CLONE_GIT_REVISION}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

BDEPEND=""
DEPEND=""
RDEPEND=""

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/darts-clone-${DARTS_CLONE_GIT_REVISION}"
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

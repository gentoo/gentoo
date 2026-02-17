# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

[[ ${PV} == 1.1.15 ]] && COMMIT=966b1210b987f39e0c18bdf43ff509fe4fb0f2e3

DESCRIPTION="Quickly navigate the file system based on your cd history"
HOMEPAGE="https://github.com/badmotorfinger/z/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/badmotorfinger/z"
else
	SRC_URI="https://github.com/badmotorfinger/z/archive/${COMMIT}.tar.gz
		-> ${P}.snapshot.gh.tar.gz"
	S="${WORKDIR}/z-${COMMIT}"

	KEYWORDS="~amd64"
fi

LICENSE="public-domain"
SLOT="${PV%%_p*}"

RDEPEND="
	virtual/pwsh:*
"

src_compile() {
	# Script-only module. Nothing to do here.
	:
}

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/z/${SLOT}"
	doins z.*
	einstalldocs
}

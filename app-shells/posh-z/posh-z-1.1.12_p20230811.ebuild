# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Quickly navigate the file system based on your cd history"
HOMEPAGE="https://github.com/badmotorfinger/z/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/badmotorfinger/z.git"
else
	if [[ "${PV}" == *_p20230811 ]] ; then
		COMMIT="ca1c8d9f004eede2ba907da199bde542d9eff344"

		SRC_URI="https://github.com/badmotorfinger/z/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}/z-${COMMIT}"
	else
		SRC_URI="https://github.com/badmotorfinger/z/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}/z-${PV}"
	fi

	KEYWORDS="~amd64"
fi

LICENSE="public-domain"
SLOT="${PV%%_p*}"

RDEPEND="virtual/pwsh:*"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/z/${SLOT}"
	doins z.*

	einstalldocs
}

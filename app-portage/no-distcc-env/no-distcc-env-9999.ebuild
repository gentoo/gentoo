# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"

if [[ ${PV} == 9999* ]]; then
	GIT_ECLASS="git-r3"
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
fi

inherit ${GIT_ECLASS}

DESCRIPTION="package.env files to disable distcc on a per-package basis"
HOMEPAGE="https://gitweb.gentoo.org/proj/no-distcc-env.git/"

LICENSE="public-domain"
SLOT="0"

src_install() {
	insinto /etc/portage
	doins -r "${WORKDIR}/${P}"/env
	doins -r "${WORKDIR}/${P}"/package.env
}

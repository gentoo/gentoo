# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
fi

inherit ${GIT_ECLASS}

DESCRIPTION="package.env files to disable distcc on a per-package basis"
HOMEPAGE="https://gitweb.gentoo.org/proj/no-distcc-env.git/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://github.com/anholt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="public-domain"
SLOT="0"
IUSE=""

src_unpack() {
	default
	[[ ${PV} = 9999* ]] && git-r3_src_unpack
}

src_install() {
	insinto /etc/portage
	doins -r "${WORKDIR}/${P}"/env
	doins -r "${WORKDIR}/${P}"/package.env
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7,8,9,10} )
inherit distutils-r1

DESCRIPTION="The ultimate statusline/prompt utility"
HOMEPAGE="https://github.com/powerline/powerline"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/powerline/powerline"
	EGIT_BRANCH="develop"
	S="${WORKDIR}/powerline-${PV}"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}-status/${PN}-status-${PV}.tar.gz"
	S="${WORKDIR}/${PN}-status-${PV}"
	KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="Apache-2.0"
SLOT="0"

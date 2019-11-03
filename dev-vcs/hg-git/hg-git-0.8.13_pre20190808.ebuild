# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

HGID="aa15905ca87f"
DESCRIPTION="push to and pull from a Git repository using Mercurial"
HOMEPAGE="http://hg-git.github.io https://pypi.org/project/hg-git/"
if [[ ${PV} == *_pre* ]] ; then
	SRC_URI="https://bitbucket.org/durin42/${PN}/get/${HGID}.zip -> ${P}.zip"
	S=${WORKDIR}/durin42-${PN}-${HGID}
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-vcs/mercurial-3.6[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.9.7[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND="app-arch/unzip"

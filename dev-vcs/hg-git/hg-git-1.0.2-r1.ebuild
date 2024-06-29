# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

MY_PV=${PV/_rc/a}
DESCRIPTION="push to and pull from a Git repository using Mercurial"
HOMEPAGE="https://hg-git.github.io https://pypi.org/project/hg-git/"
SRC_URI="https://foss.heptapod.net/mercurial/hg-git/-/archive/${MY_PV}/${PN}-${MY_PV}.tar.bz2 https://foss.heptapod.net/mercurial/hg-git/-/commit/9a52223a95e9821b2f2b544ab5a35e06963da3f1.patch -> ${MY_PV}-hg65.patch"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-vcs/mercurial-5.2[${PYTHON_USEDEP}]
	>=dev-python/dulwich-0.19.3[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	eapply "${DISTDIR}"/${MY_PV}-hg65.patch
}

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-pkgdev-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${PKGDEV_DOCS_PREBUILT:=1}

PKGDEV_DOCS_PREBUILT_DEV=sam
PKGDEV_DOCS_VERSION=$(ver_cut 1-3)
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
PKGDEV_DOCS_USEFLAG="+doc"

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	PKGDEV_DOCS_PREBUILT=0

	EGIT_REPO_URI="https://github.com/pkgcore/pkgdev.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

	if [[ ${PKGDEV_DOCS_PREBUILT} == 1 ]] ; then
		SRC_URI+=" !doc? ( https://dev.gentoo.org/~${PKGDEV_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${PKGDEV_DOCS_VERSION}-docs.tar.xz )"
	fi

	KEYWORDS="amd64 arm arm64 hppa ~loong ppc ppc64 ~riscv sparc x86 ~x64-macos"
fi

DESCRIPTION="Collection of tools for Gentoo development"
HOMEPAGE="https://github.com/pkgcore/pkgdev"

LICENSE="BSD MIT"
SLOT="0"

[[ ${PKGDEV_DOCS_PREBUILT} == 1 ]] && PKGDEV_DOCS_USEFLAG="doc"

IUSE="${PKGDEV_DOCS_USEFLAG}"

if [[ ${PV} == *9999 ]] ; then
	# https://github.com/pkgcore/pkgdev/blob/main/requirements/dev.txt
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~dev-util/pkgcheck-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]
	"
else
	# https://github.com/pkgcore/pkgdev/blob/main/requirements/install.txt
	RDEPEND="
		>=dev-python/snakeoil-0.9.12[${PYTHON_USEDEP}]
		>=dev-util/pkgcheck-0.10.0[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.12.13[${PYTHON_USEDEP}]
	"
fi

# Uses pytest but we want to use the setup.py runner to get generated modules
BDEPEND+="test? ( dev-python/pytest )"
RDEPEND+="dev-vcs/git"

PATCHES=(
	"${FILESDIR}"/${P}-fix-signoff-example.patch
)

distutils_enable_sphinx doc
distutils_enable_tests setup.py

python_compile_all() {
	use doc && emake -C doc man

	# HTML pages only
	sphinx_compile_all
}

python_install_all() {
	# If USE=doc, there'll be newly generated docs which we install instead.
	if use doc ; then
		doman doc/_build/man/*
	elif ! use doc && [[ ${PKGDEV_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${PKGDEV_DOCS_VERSION}-docs/man/*.[0-8]
	fi

	distutils-r1_python_install_all
}

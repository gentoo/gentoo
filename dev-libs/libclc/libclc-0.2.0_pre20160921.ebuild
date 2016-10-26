# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

EGIT_REPO_URI="http://llvm.org/git/${PN}.git
	https://github.com/llvm-mirror/${PN}.git"
EGIT_COMMIT="520743b0b72862a987ead6213dc1a5321a2010f9"

if [[ ${PV} = 9999* ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
else
	GIT_ECLASS="vcs-snapshot"
fi

inherit python-any-r1 ${GIT_ECLASS}

DESCRIPTION="OpenCL C library"
HOMEPAGE="http://libclc.llvm.org/"

if [[ ${PV} = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
else
	SRC_URI="https://github.com/llvm-mirror/libclc/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz
		${SRC_PATCHES}"
fi

LICENSE="|| ( MIT BSD )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=sys-devel/clang-3.9
	>=sys-devel/llvm-3.9"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

src_configure() {
	./configure.py \
		--with-llvm-config="${EPREFIX}/usr/bin/llvm-config" \
		--prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake VERBOSE=1
}

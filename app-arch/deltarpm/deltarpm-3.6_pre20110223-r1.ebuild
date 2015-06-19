# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/deltarpm/deltarpm-3.6_pre20110223-r1.ebuild,v 1.1 2014/12/25 00:13:21 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils toolchain-funcs python-single-r1

SNAPSHOT="20110223"

DESCRIPTION="tools to create and apply deltarpms"
HOMEPAGE="http://gitorious.org/deltarpm/deltarpm"
SRC_URI="http://pkgs.fedoraproject.org/repo/pkgs/${PN}/${PN}-git-${SNAPSHOT}.tar.bz2/70f8884be63614ca7c3fc888cf20ebc8/${PN}-git-${SNAPSHOT}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

RDEPEND="sys-libs/zlib
	app-arch/xz-utils
	app-arch/bzip2
	<app-arch/rpm-5
	python? ( ${PYTHON_DEPS} )"
DEPEND=${RDEPEND}

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S="${WORKDIR}/${PN}-git-${SNAPSHOT}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e '/^prefix/s:/local::' \
		-e '/^mandir/s:/man:/share/man:' \
		Makefile || die
	epatch "${FILESDIR}/3.6_pre20110223-build.patch"
}

src_compile() {
	emake -j1 CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"

	if use python; then
		emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)" python
	fi
}

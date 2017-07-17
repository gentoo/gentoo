# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

WANT_AUTOMAKE=1.9

inherit autotools eutils subversion

DESCRIPTION="A makefile framework for writing simple makefiles for complex tasks"
HOMEPAGE="http://svn.netlabs.org/kbuild/wiki"
ESVN_REPO_URI="http://svn.netlabs.org/repos/kbuild/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-devel/gettext
	virtual/yacc"
RDEPEND=""

S="${WORKDIR}/${MY_P/-src}"

src_prepare() {
		default
		rm -rf "${S}/kBuild/bin" || die

		cd "${S}/src/kmk" || die
		eautoreconf
		cd "${S}/src/sed" || die
		eautoreconf
}

src_compile() {
		kBuild/env.sh --full \
		make -f bootstrap.gmk AUTORECONF=true \
		|| die "bootstrap failed"
}

src_install() {
		kBuild/env.sh kmk \
		NIX_INSTALL_DIR=/usr \
		PATH_INS="${D}" \
		install || die "install failed"
}

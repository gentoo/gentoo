# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools subversion

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

pkg_setup() {
	# Package fails with distcc (bug #255371)
	export DISTCC_DISABLE=1
}

src_prepare() {
	default
	rm -rf "${S}/kBuild/bin" || die

	# bootstrapping breaks because of missing po/Makefile.in.in
	sed '/^AC_CONFIG_FILES/s@ po/Makefile\.in@@' \
		-i src/kmk/configure.ac || die

	cd "${S}/src/kmk" || die
	eautoreconf
	cd "${S}/src/sed" || die
	eautoreconf
}

src_compile() {
	kBuild/env.sh --full \
		emake -f bootstrap.gmk AUTORECONF=true \
		|| die "bootstrap failed"
}

src_install() {
	kBuild/env.sh kmk \
		NIX_INSTALL_DIR=/usr \
		PATH_INS="${D}" \
		install \
		|| die "install failed"
}

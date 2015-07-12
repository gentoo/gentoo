# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pkgcore/pkgcore-9999.ebuild,v 1.25 2015/07/12 19:31:44 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcore.git"
	inherit git-r3
else
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore package manager"
HOMEPAGE="https://github.com/pkgcore/pkgcore"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
IUSE="doc test"

RDEPEND="=dev-python/snakeoil-9999[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/pyparsing[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )
"

pkg_setup() {
	# disable snakeoil 2to3 caching...
	unset PY2TO3_CACHEDIR

	mydistutilsargs=(
		build
		--disable-html-docs
		--disable-man-pages
	)
}

python_compile_all() {
	esetup.py $(use doc && echo 'build_docs')

	if [[ ${PV} == *9999 ]]; then
		esetup.py build_man
		ln -s "${BUILD_DIR}/sphinx/man" man || die
	fi

	# symlinks generated manpages into source root
	# dead symlinks are tolerated
	ln -s "${BUILD_DIR}/sphinx/html" html || die
}

python_test() {
	esetup.py test
}

src_install() {
	mydistutilsargs+=(
		install
		--disable-html-docs
		--disable-man-pages
	)

	distutils-r1_src_install
}

python_install_all() {
	local cmds=(
		install_man
	)
	use doc && cmds+=(
		install_docs --path="${ED%/}"/usr/share/doc/${PF}/html
	)

	distutils-r1_python_install "${cmds[@]}"
	distutils-r1_python_install_all

	insinto /usr/share/zsh/site-functions
	doins completion/zsh/*
}

pkg_postinst() {
	python_foreach_impl pplugincache
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE='threads(+)'

inherit python-single-r1 waf-utils bash-completion-r1 multilib-build multilib-minimal

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://drobilla.net/software/lilv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 ~sparc x86"
IUSE="doc +dyn-manifest static-libs test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		dev-python/sphinx_lv2_theme
	)
	test? (
		$(python_gen_cond_dep '
			dev-python/unittest2[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/serd[${MULTILIB_USEDEP}]
	dev-libs/sord[${MULTILIB_USEDEP}]
	media-libs/libsndfile
	media-libs/lv2[${MULTILIB_USEDEP}]
	media-libs/sratom[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

pkg_setup() {
	python_setup
}

src_prepare() {
	default
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	multilib_copy_sources
}

multilib_src_configure() {
	waf-utils_src_configure \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--no-bash-completion \
		$(multilib_native_usex doc --docs "") \
		$(usex test --test "") \
		$(usex static-libs --static "") \
		$(usex dyn-manifest --dyn-manifest "")
}

multilib_src_compile() {
	./waf build || die
}

multilib_src_test() {
	./waf test || die
}

multilib_src_install() {
	waf-utils_src_install
}

multilib_src_install_all() {
	sed -i "/lv2jack/d" utils/lilv.bash_completion
	newbashcomp utils/lilv.bash_completion lv2info

	dodir /etc/env.d
	echo "LV2_PATH=${EPREFIX}/usr/$(get_libdir)/lv2" > "${ED}/etc/env.d/60lv2"

	python_optimize
}

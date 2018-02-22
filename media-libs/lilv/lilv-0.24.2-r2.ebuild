# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
PYTHON_REQ_USE='threads(+)'

inherit python-any-r1 waf-utils bash-completion-r1 multilib-build multilib-minimal

DESCRIPTION="Library to make the use of LV2 plugins as simple as possible for applications"
HOMEPAGE="http://drobilla.net/software/lilv/"
SRC_URI="http://download.drobilla.net/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="doc +dyn-manifest static-libs test"

RDEPEND=">=media-libs/lv2-1.14.0-r1[${MULTILIB_USEDEP}]
	>=media-libs/sratom-0.6.0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/serd-0.28.0-r1[${MULTILIB_USEDEP}]
	>=dev-libs/sord-0.16.0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

DOCS=( "AUTHORS" "NEWS" "README" )

src_prepare() {
	epatch "${FILESDIR}/includedir.patch"
	sed -i -e 's/^.*run_ldconfig/#\0/' wscript || die
	default
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

multilib_src_test() {
	./waf test || die
}

multilib_src_install() {
	waf-utils_src_install
}

multilib_src_install_all() {
	newbashcomp utils/lilv.bash_completion ${PN}
}

# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
inherit autotools distutils-r1

COMMIT="8e0ba724d85de2c89f48161807e878667b9ed089"  # v4.9.0 tag
DESCRIPTION="A file watching service"
HOMEPAGE="https://facebook.github.io/watchman/"
SRC_URI="https://github.com/facebook/watchman/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pcre python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="pcre? ( dev-libs/libpcre )
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-python3.patch"
	"${FILESDIR}/${PV}-changes.patch"
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--enable-lenient \
		--disable-statedir \
		--without-python \
		$(use_with pcre)
}

src_compile() {
	default

	if use python; then
		pushd python >/dev/null || die
		distutils-r1_src_compile
		popd >/dev/null || die
	fi
}

src_install() {
	default

	if use python; then
		pushd python >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi
}

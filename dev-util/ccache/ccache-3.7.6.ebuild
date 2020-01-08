# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="fast compiler cache"
HOMEPAGE="https://ccache.dev/"
SRC_URI="https://github.com/ccache/ccache/releases/download/v${PV}/ccache-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sh sparc ~x86"
IUSE="test"

DEPEND="app-arch/xz-utils
	sys-libs/zlib"
RDEPEND="${DEPEND}
	dev-util/shadowman
	sys-apps/gentoo-functions"
# clang-specific tests use it to compare objects for equality.
# Let's pull in the dependency unconditionally.
DEPEND+="
	test? ( dev-libs/elfutils )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-nvcc-test.patch
)

src_prepare() {
	default

	# make sure we always use system zlib
	rm -rf src/zlib || die
	sed \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		"${FILESDIR}"/ccache-config-3 > ccache-config || die
}

src_compile() {
	emake V=1
}

src_test() {
	emake check V=1
}

src_install() {
	DOCS=( doc/{AUTHORS,MANUAL,NEWS}.adoc CONTRIBUTING.md README.md )
	default

	dobin ccache-config
	insinto /usr/share/shadowman/tools
	newins - ccache <<<'/usr/lib/ccache/bin'

	DOC_CONTENTS="
To use ccache with **non-Portage** C compiling, add
'${EPREFIX}/usr/lib/ccache/bin' to the beginning of your path, before
'${EPREFIX}/usr/bin'. Portage will automatically take advantage of ccache with
no additional steps.  If this is your first install of ccache, type
something like this to set a maximum cache size of 2GB:\\n
# ccache -M 2G\\n
If you are upgrading from an older version than 3.x you should clear all of your caches like so:\\n
# CCACHE_DIR='${CCACHE_DIR:-${PORTAGE_TMPDIR}/ccache}' ccache -C\\n
ccache now supports sys-devel/clang and dev-lang/icc, too!"

	readme.gentoo_create_doc
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && ${ROOT:-/} == / ]] ; then
		eselect compiler-shadow remove ccache
	fi
}

pkg_postinst() {
	if [[ ${ROOT:-/} == / ]]; then
		eselect compiler-shadow update ccache
	fi

	# nuke broken symlinks from previous versions that shouldn't exist
	rm -rf "${EROOT}"/usr/lib/ccache.backup || die

	readme.gentoo_print_elog
}

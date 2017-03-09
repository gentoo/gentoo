# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils readme.gentoo-r1

DESCRIPTION="fast compiler cache"
HOMEPAGE="http://ccache.samba.org/"
SRC_URI="http://samba.org/ftp/ccache/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="app-arch/xz-utils
	sys-libs/zlib"
RDEPEND="${DEPEND}
	sys-apps/gentoo-functions"

src_prepare() {
	# make sure we always use system zlib
	rm -rf zlib || die
	epatch "${FILESDIR}"/${PN}-3.1.10-size-on-disk.patch #456178
	sed \
		-e "/^EPREFIX=/s:'':'${EPREFIX}':" \
		"${FILESDIR}"/ccache-config-3 > ccache-config || die
}

src_install() {
	DOCS=( AUTHORS.txt MANUAL.txt NEWS.txt README.txt )
	default

	dobin ccache-config

	DOC_CONTENTS="
To use ccache with **non-Portage** C compiling, add
${EPREFIX}/usr/lib/ccache/bin to the beginning of your path, before ${EPREFIX}/usr/bin.
Portage 2.0.46-r11+ will automatically take advantage of ccache with
no additional steps.  If this is your first install of ccache, type
something like this to set a maximum cache size of 2GB:\\n
# ccache -M 2G\\n
If you are upgrading from an older version than 3.x you should clear all of your caches like so:\\n
# CCACHE_DIR='${CCACHE_DIR:-${PORTAGE_TMPDIR}/ccache}' ccache -C\\n
ccache now supports sys-devel/clang and dev-lang/icc, too!"

	readme.gentoo_create_doc
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} ]] ; then
		"${EROOT}"/usr/bin/ccache-config --remove-links
		"${EROOT}"/usr/bin/ccache-config --remove-links ${CHOST}
	fi
}

pkg_postinst() {
	"${EROOT}"/usr/bin/ccache-config --install-links
	"${EROOT}"/usr/bin/ccache-config --install-links ${CHOST}

	# nuke broken symlinks from previous versions that shouldn't exist
	rm -f "${EROOT}"/usr/lib/ccache/bin/${CHOST}-cc || die
	rm -rf "${EROOT}"/usr/lib/ccache.backup || die

	readme.gentoo_print_elog
}

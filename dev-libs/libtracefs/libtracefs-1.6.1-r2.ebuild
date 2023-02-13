# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Linux kernel trace file system library"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/"

if [[ ${PV} =~ [9]{4,} ]]; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/snapshot/${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

RDEPEND="
	!<dev-util/trace-cmd-3.1.4-r2
	>=dev-libs/libtraceevent-1.3.0
"
DEPEND="${RDEPEND}"
# source-highlight is needed, see bug https://bugs.gentoo.org/865469
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/xmlto app-text/asciidoc dev-util/source-highlight )
"

src_configure() {
	EMAKE_FLAGS=(
		"prefix=${EPREFIX}/usr"
		"libdir=${EPREFIX}/usr/$(get_libdir)"
		"CC=$(tc-getCC)"
		"AR=$(tc-getAR)"
		VERBOSE=1
	)
}

src_compile() {
	emake "${EMAKE_FLAGS[@]}"
	use doc && emake doc
}

src_install() {
	emake "${EMAKE_FLAGS[@]}" DESTDIR="${ED}" install
	# can't prevent installation of the static lib with parameters
	rm "${ED}/usr/$(get_libdir)/libtracefs.a" || die
	# install-doc is wrong target, see https://bugs.gentoo.org/865465
	use doc && emake "${EMAKE_FLAGS[@]}" DESTDIR="${ED}" install_doc
}

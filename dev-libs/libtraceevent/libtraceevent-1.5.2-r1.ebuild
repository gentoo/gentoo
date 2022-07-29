# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Linux kernel trace event library"
HOMEPAGE="https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/"

if [[ ${PV} =~ [9]{4,} ]]; then
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/"
	inherit git-r3
else
	SRC_URI="https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/snapshot/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc"

RDEPEND="
	!<dev-util/trace-cmd-3.0
"
BDEPEND="
	doc? ( app-text/xmlto app-text/asciidoc )
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
	rm "${ED}/usr/$(get_libdir)/libtraceevent.a" || die
	use doc && emake "${EMAKE_FLAGS[@]}" DESTDIR="${ED}" install-doc
}
